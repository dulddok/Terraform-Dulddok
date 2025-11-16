# PrivateLink Service 모듈 변수 정의

variable "project_name" {
  description = "프로젝트 이름"
  type        = string
}

variable "environment" {
  description = "환경 (dev, staging, prod)"
  type        = string
}

variable "network_load_balancer_arns" {
  description = "Network Load Balancer ARN 목록"
  type        = list(string)
}

variable "acceptance_required" {
  description = "연결 승인이 필요한지 여부"
  type        = bool
  default     = false
}

variable "allowed_principals" {
  description = "허용된 AWS 계정/역할 ARN 목록 (승인 불필요 시)"
  type        = list(string)
  default     = []
}

variable "auto_accept_principals" {
  description = "자동 승인할 AWS 계정/역할 ARN 목록"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "추가 태그"
  type        = map(string)
  default     = {}
}

