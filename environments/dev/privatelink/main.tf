# PrivateLink 서비스 구성
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

# Security Group for NLB (PrivateLink용)
resource "aws_security_group" "nlb" {
  name_prefix = "${var.project_name}-${var.environment}-nlb-"
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
    Name = "${var.project_name}-${var.environment}-nlb-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Security Group for EC2 (서비스 제공자)
resource "aws_security_group" "service_ec2" {
  name_prefix = "${var.project_name}-${var.environment}-service-ec2-"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.nlb.id]
    description     = "HTTP from NLB"
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.nlb.id]
    description     = "HTTPS from NLB"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.networking.outputs.vpc_cidr_block]
    description = "SSH from VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-service-ec2-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# NLB 모듈 (Cross-AZ 테스트용)
module "nlb" {
  source = "../../../../modules/nlb"

  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.terraform_remote_state.networking.outputs.vpc_id
  subnet_ids     = data.terraform_remote_state.networking.outputs.private_subnet_ids
  internal       = true
  listener_port  = 80
  listener_protocol = "TCP"
  target_port    = 80
  target_protocol = "TCP"

  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Service     = "privatelink"
  }
}

# Cross-AZ 테스트용 EC2 인스턴스 (다른 AZ에 배치)
resource "aws_instance" "service_instances" {
  count = length(data.terraform_remote_state.networking.outputs.private_subnet_ids)

  ami           = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = data.terraform_remote_state.networking.outputs.private_subnet_ids[count.index]
  
  vpc_security_group_ids = [aws_security_group.service_ec2.id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    
    # Cross-AZ 테스트를 위한 간단한 웹 서버
    echo "<h1>PrivateLink Service Instance - AZ ${count.index + 1}</h1>" > /var/www/html/index.html
    echo "<p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>" >> /var/www/html/index.html
    echo "<p>Availability Zone: $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>" >> /var/www/html/index.html
    echo "<p>Private IP: $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)</p>" >> /var/www/html/index.html
  EOF

  tags = {
    Name        = "${var.project_name}-${var.environment}-service-instance-${count.index + 1}"
    AZ          = data.terraform_remote_state.networking.outputs.private_subnet_ids[count.index]
    ServiceType = "PrivateLinkProvider"
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

# Target Group에 EC2 인스턴스 등록
resource "aws_lb_target_group_attachment" "service_instances" {
  count = length(aws_instance.service_instances)

  target_group_arn = module.nlb.target_group_arn
  target_id        = aws_instance.service_instances[count.index].id
  port             = 80
}

# PrivateLink Service 생성
module "privatelink_service" {
  source = "../../../../modules/privatelink-service"

  project_name               = var.project_name
  environment                = var.environment
  network_load_balancer_arns = [module.nlb.nlb_arn]
  acceptance_required        = var.acceptance_required
  allowed_principals          = var.allowed_principals
  auto_accept_principals      = var.auto_accept_principals

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Service     = "privatelink"
  }
}

# Route53 Private Hosted Zone 생성 (Local DNS)
module "route53_private_zone" {
  source = "../../../../modules/route53-private-zone"

  project_name = var.project_name
  environment  = var.environment
  zone_name    = var.dns_zone_name
  vpc_id       = data.terraform_remote_state.networking.outputs.vpc_id
  vpc_region   = var.aws_region

  # DNS 레코드는 PrivateLink 연결 후 VPC Endpoint DNS를 사용하는 것이 더 적절합니다
  # 여기서는 NLB를 직접 가리키는 CNAME 레코드로 설정 (또는 PrivateLink 사용 시 VPC Endpoint DNS 사용)
  # dns_records = {}  # VPC Endpoint 생성 후 별도로 설정

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Service     = "privatelink"
  }
}

