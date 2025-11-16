# VPC 모듈 변수 정의

variable "project_name" {
  description = "프로젝트 이름"
  type        = string
}

variable "environment" {
  description = "환경 (dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod"
  }
}

variable "vpc_cidr" {
  description = "VPC CIDR 블록"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid CIDR block (e.g., 10.0.0.0/16)"
  }
}

variable "availability_zones" {
  description = "사용할 가용 영역 목록"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public 서브넷 CIDR 블록 목록 (availability_zones와 개수가 일치해야 함)"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private 서브넷 CIDR 블록 목록 (availability_zones와 개수가 일치해야 함)"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "NAT Gateway 활성화 여부"
  type        = bool
  default     = true
}

variable "tags" {
  description = "추가 태그"
  type        = map(string)
  default     = {}
}
