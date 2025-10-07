# AWS Provider 설정
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "staging"
      Project     = var.project_name
      Service     = "compute"
      ManagedBy   = "terraform"
    }
  }
}
