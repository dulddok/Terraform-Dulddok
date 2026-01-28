# Networking 서비스 - VPC 구성 (Staging)
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# VPC 모듈 호출
module "vpc" {
  source = "../../../modules/vpc"

  project_name           = var.project_name
  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  availability_zones    = var.availability_zones
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  enable_nat_gateway    = true

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Service     = "networking"
  }
}
