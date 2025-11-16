# PrivateLink 소비자 구성 (VPC Endpoint 사용)
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Networking 서비스의 출력값 가져오기
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket         = var.backend_config.bucket
    key            = var.backend_config.networking_key
    region         = var.aws_region
    encrypt        = true
    dynamodb_table = var.backend_config.dynamodb_table
  }
}

# PrivateLink 서비스의 출력값 가져오기
data "terraform_remote_state" "privatelink" {
  backend = "s3"
  config = {
    bucket         = var.backend_config.bucket
    key            = var.backend_config.privatelink_key
    region         = var.aws_region
    encrypt        = true
    dynamodb_table = var.backend_config.dynamodb_table
  }
}

# Security Group for VPC Endpoint
resource "aws_security_group" "vpce" {
  name_prefix = "${var.project_name}-${var.environment}-vpce-"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.networking.outputs.vpc_cidr_block]
    description = "HTTP from VPC"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.networking.outputs.vpc_cidr_block]
    description = "HTTPS from VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-vpce-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# VPC Endpoint 생성 (PrivateLink 소비자)
module "vpc_endpoint" {
  source = "../../../../modules/vpc-endpoint"

  project_name      = var.project_name
  environment       = var.environment
  endpoint_name     = "privatelink-service"
  vpc_id            = data.terraform_remote_state.networking.outputs.vpc_id
  service_name      = data.terraform_remote_state.privatelink.outputs.vpc_endpoint_service_name
  subnet_ids        = data.terraform_remote_state.networking.outputs.private_subnet_ids
  security_group_ids = [aws_security_group.vpce.id]
  private_dns_enabled = true
  auto_accept        = var.auto_accept

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Service     = "privatelink-consumer"
  }
}

# 각 서브넷의 ENI 정보를 가져오기 위한 데이터 소스
# VPC Endpoint의 DNS 엔트리는 서브넷 순서와 동일하게 반환됩니다
data "aws_subnet" "private_subnets" {
  count = length(data.terraform_remote_state.networking.outputs.private_subnet_ids)
  id    = data.terraform_remote_state.networking.outputs.private_subnet_ids[count.index]
}

# Route53 Private Hosted Zone에 VPC Endpoint DNS 레코드 추가 (AZ별 최적화)
module "route53_private_zone" {
  source = "../../../../modules/route53-private-zone"

  project_name = var.project_name
  environment  = var.environment
  zone_name    = var.dns_zone_name
  vpc_id       = data.terraform_remote_state.networking.outputs.vpc_id
  vpc_region   = var.aws_region

  # VPC Endpoint의 DNS 엔트리를 AZ별로 매핑하여 DNS 레코드 생성
  # 각 AZ의 인스턴스가 같은 AZ의 ENI를 사용하도록 최적화
  dns_records = var.use_az_local_dns ? {
    for idx, az in data.aws_subnet.private_subnets[*].availability_zone : 
    # AZ별로 별도의 DNS 레코드 생성 (예: service-az1.privatelink.local)
    "service-${replace(az, "-", "")}" => {
      name    = "${var.dns_service_name}-${replace(az, "-", "")}"
      type    = "A"
      records = [module.vpc_endpoint.vpc_endpoint_dns_entries[idx].dns_name]
    }
  } : {
    # 기본 설정: 모든 AZ의 ENI를 하나의 레코드에 포함
    # (클라이언트가 자동으로 가까운 ENI 선택, 하지만 Cross-AZ 트래픽 가능)
    "service" = {
      name    = var.dns_service_name
      type    = "A"
      records = [for entry in module.vpc_endpoint.vpc_endpoint_dns_entries : entry.dns_name]
    }
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Service     = "privatelink-consumer"
  }
}

# Cross-AZ 테스트용 클라이언트 EC2 인스턴스
resource "aws_instance" "client_instances" {
  count = length(data.terraform_remote_state.networking.outputs.private_subnet_ids)

  ami           = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = data.terraform_remote_state.networking.outputs.private_subnet_ids[count.index]

  vpc_security_group_ids = [aws_security_group.client.id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y curl
    
    # 현재 인스턴스의 AZ 확인
    INSTANCE_AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
    AZ_SHORT=$(echo $INSTANCE_AZ | tr -d '-')
    
    # PrivateLink 서비스 테스트 스크립트
    USE_AZ_LOCAL_DNS="${var.use_az_local_dns}"
    SERVICE_BASE="${var.dns_service_name}"
    cat > /home/ec2-user/test-privatelink.sh <<SCRIPT
#!/bin/bash
INSTANCE_AZ=\$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
AZ_SHORT=\$(echo \$INSTANCE_AZ | tr -d '-')

echo "=== PrivateLink 연결 테스트 ==="
echo "Instance AZ: \$INSTANCE_AZ"
echo ""

# AZ별 로컬 DNS 사용 여부에 따라 다른 DNS 이름 사용
if [ "$USE_AZ_LOCAL_DNS" = "true" ]; then
  SERVICE_DNS="$SERVICE_BASE-\$AZ_SHORT"
  echo "Using AZ-local DNS: \$SERVICE_DNS (same AZ ENI - cost optimized)"
else
  SERVICE_DNS="$SERVICE_BASE"
  echo "Using shared DNS: \$SERVICE_DNS (any AZ ENI)"
fi

echo "Testing connectivity to: \$SERVICE_DNS"
curl -v http://\$SERVICE_DNS || echo "Connection failed"
echo ""
echo "Alternative: Direct VPC Endpoint DNS"
echo "Note: VPC Endpoint automatically routes to nearest ENI when using default DNS"
SCRIPT
    chmod +x /home/ec2-user/test-privatelink.sh
    chown ec2-user:ec2-user /home/ec2-user/test-privatelink.sh
  EOF

  tags = {
    Name        = "${var.project_name}-${var.environment}-client-instance-${count.index + 1}"
    AZ          = data.terraform_remote_state.networking.outputs.private_subnet_ids[count.index]
    ServiceType = "PrivateLinkConsumer"
  }
}

# Security Group for Client Instances
resource "aws_security_group" "client" {
  name_prefix = "${var.project_name}-${var.environment}-client-"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.networking.outputs.vpc_cidr_block]
    description = "SSH from VPC"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.networking.outputs.vpc_cidr_block]
    description = "HTTP from VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-client-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

