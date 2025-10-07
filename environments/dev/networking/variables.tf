# Networking 서비스 변수 정의

variable "project_name" {
  description = "프로젝트 이름"
  type        = string
  default     = "my-project"
}

variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "environment" {
  description = "환경"
  type        = string
  default     = "dev"
}

variable "availability_zones" {
  description = "사용할 가용 영역"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "vpc_cidr" {
  description = "VPC CIDR 블록"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public 서브넷 CIDR 블록"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private 서브넷 CIDR 블록"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

