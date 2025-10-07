# IAM 모듈 변수 정의

variable "project_name" {
  description = "프로젝트 이름"
  type        = string
}

variable "environment" {
  description = "환경 (dev, staging, prod)"
  type        = string
}

variable "role_name" {
  description = "IAM 역할 이름"
  type        = string
  default     = "role"
}

variable "policy_name" {
  description = "IAM 정책 이름"
  type        = string
  default     = "policy"
}

variable "user_name" {
  description = "IAM 사용자 이름"
  type        = string
  default     = "user"
}

variable "instance_profile_name" {
  description = "IAM 인스턴스 프로파일 이름"
  type        = string
  default     = "instance-profile"
}

variable "create_role" {
  description = "IAM 역할 생성 여부"
  type        = bool
  default     = true
}

variable "create_policy" {
  description = "IAM 정책 생성 여부"
  type        = bool
  default     = true
}

variable "create_user" {
  description = "IAM 사용자 생성 여부"
  type        = bool
  default     = false
}

variable "create_access_key" {
  description = "IAM 액세스 키 생성 여부"
  type        = bool
  default     = false
}

variable "create_instance_profile" {
  description = "IAM 인스턴스 프로파일 생성 여부"
  type        = bool
  default     = false
}

variable "assume_role_policy" {
  description = "Assume Role 정책 JSON"
  type        = string
  default     = null
}

variable "policy_document" {
  description = "정책 문서 JSON"
  type        = string
  default     = null
}

variable "policy_description" {
  description = "정책 설명"
  type        = string
  default     = "Terraform managed policy"
}

variable "existing_role_name" {
  description = "기존 역할 이름 (인스턴스 프로파일용)"
  type        = string
  default     = null
}

variable "tags" {
  description = "추가 태그"
  type        = map(string)
  default     = {}
}

