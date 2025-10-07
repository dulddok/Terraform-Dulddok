# S3 모듈 변수 정의

variable "project_name" {
  description = "프로젝트 이름"
  type        = string
}

variable "environment" {
  description = "환경 (dev, staging, prod)"
  type        = string
}

variable "bucket_name" {
  description = "S3 버킷 이름 (고유해야 함)"
  type        = string
}

variable "versioning_enabled" {
  description = "버전 관리 활성화 여부"
  type        = bool
  default     = true
}

variable "encryption_algorithm" {
  description = "암호화 알고리즘"
  type        = string
  default     = "AES256"
}

variable "bucket_key_enabled" {
  description = "버킷 키 활성화 여부"
  type        = bool
  default     = false
}

variable "block_public_acls" {
  description = "퍼블릭 ACL 차단 여부"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "퍼블릭 정책 차단 여부"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "퍼블릭 ACL 무시 여부"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "퍼블릭 버킷 제한 여부"
  type        = bool
  default     = true
}

variable "lifecycle_rules_enabled" {
  description = "라이프사이클 규칙 활성화 여부"
  type        = bool
  default     = false
}

variable "transition_to_ia_days" {
  description = "IA로 전환하는 일수"
  type        = number
  default     = 30
}

variable "transition_to_glacier_days" {
  description = "Glacier로 전환하는 일수"
  type        = number
  default     = 90
}

variable "expiration_days" {
  description = "만료 일수"
  type        = number
  default     = 365
}

variable "bucket_policy" {
  description = "버킷 정책 JSON"
  type        = string
  default     = null
}

variable "tags" {
  description = "추가 태그"
  type        = map(string)
  default     = {}
}

