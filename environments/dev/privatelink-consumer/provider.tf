# AWS Provider 설정
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "dev"
      Project     = var.project_name
      Service     = "privatelink-consumer"
      ManagedBy   = "terraform"
    }
  }
}

