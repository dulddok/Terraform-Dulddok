# VPC Endpoint 모듈 (PrivateLink 소비자)
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# VPC Endpoint 생성
resource "aws_vpc_endpoint" "this" {
  vpc_id              = var.vpc_id
  service_name        = var.service_name
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = var.private_dns_enabled

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-vpce-${var.endpoint_name}"
  })
}

# Note: VPC Endpoint Connection 승인은 서비스 제공자 측에서 수행해야 합니다.
# 이는 PrivateLink 서비스 모듈에서 처리됩니다.

