# AWS Provider 설정
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "prod"
      Project     = var.project_name
      Service     = "networking"
      ManagedBy   = "terraform"
    }
  }
}
