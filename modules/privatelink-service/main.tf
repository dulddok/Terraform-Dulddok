# PrivateLink Service 모듈 (VPC Endpoint Service 제공자)
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# VPC Endpoint Service 생성 (PrivateLink)
resource "aws_vpc_endpoint_service" "this" {
  acceptance_required        = var.acceptance_required
  network_load_balancer_arns = var.network_load_balancer_arns
  allowed_principals         = var.allowed_principals

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-vpce-service"
  })
}

# VPC Endpoint Service Connection 허용 (선택적)
resource "aws_vpc_endpoint_service_allowed_principal" "this" {
  count = length(var.auto_accept_principals)

  vpc_endpoint_service_id = aws_vpc_endpoint_service.this.id
  principal_arn           = var.auto_accept_principals[count.index]
}

