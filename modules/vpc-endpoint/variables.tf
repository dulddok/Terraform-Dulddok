# VPC Endpoint 모듈 변수 정의

variable "project_name" {
  description = "프로젝트 이름"
  type        = string
}

variable "environment" {
  description = "환경 (dev, staging, prod)"
  type        = string
}

variable "endpoint_name" {
  description = "엔드포인트 이름"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "service_name" {
  description = "VPC Endpoint Service 이름 (com.amazonaws.region.service-name 또는 PrivateLink 서비스 이름)"
  type        = string
}

variable "service_id" {
  description = "VPC Endpoint Service ID (승인용, 선택적)"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "서브넷 ID 목록"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security Group ID 목록"
  type        = list(string)
  default     = []
}

variable "private_dns_enabled" {
  description = "Private DNS 활성화 여부"
  type        = bool
  default     = true
}

variable "auto_accept" {
  description = "연결 자동 승인 여부"
  type        = bool
  default     = false
}

variable "tags" {
  description = "추가 태그"
  type        = map(string)
  default     = {}
}

