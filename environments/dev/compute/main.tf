# Compute 서비스 - EC2 구성
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# Data source로 networking 서비스의 출력값 가져오기
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "dev/networking/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

# ALB 모듈 호출
module "alb" {
  source = "../../../modules/alb"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = data.terraform_remote_state.networking.outputs.vpc_id
  public_subnet_ids = data.terraform_remote_state.networking.outputs.public_subnet_ids

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Service     = "alb"
  }
}

# EC2 모듈 호출
module "ec2" {
  source = "../../../modules/ec2"

  project_name           = var.project_name
  environment            = var.environment
  vpc_id                 = data.terraform_remote_state.networking.outputs.vpc_id
  subnet_ids             = data.terraform_remote_state.networking.outputs.private_subnet_ids
  instance_type          = var.instance_type
  min_size               = var.min_size
  max_size               = var.max_size
  desired_capacity       = var.desired_capacity
  target_group_arns      = [module.alb.target_group_arn]
  user_data              = var.user_data
  alb_security_group_ids = [module.alb.alb_security_group_id]

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Service     = "compute"
  }
}
