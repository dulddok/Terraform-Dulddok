# Compute 서비스 - EC2 구성 (Staging)
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
    key    = "staging/networking/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

# EC2 모듈 호출
module "ec2" {
  source = "../../../modules/ec2"

  project_name     = var.project_name
  environment      = var.environment
  vpc_id           = data.terraform_remote_state.networking.outputs.vpc_id
  subnet_ids       = data.terraform_remote_state.networking.outputs.private_subnet_ids
  instance_type    = var.instance_type
  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity
  create_key_pair  = false
  key_name         = "existing-key" # 실제 키 이름으로 변경 필요

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Service     = "compute"
  }
}
