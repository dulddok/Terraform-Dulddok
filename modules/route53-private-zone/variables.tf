# Route53 Private Hosted Zone 모듈 변수 정의

variable "project_name" {
  description = "프로젝트 이름"
  type        = string
}

variable "environment" {
  description = "환경 (dev, staging, prod)"
  type        = string
}

variable "zone_name" {
  description = "Private Hosted Zone 이름 (예: example.local)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_region" {
  description = "VPC 리전"
  type        = string
  default     = null
}

variable "dns_records" {
  description = "DNS 레코드 맵 (key: 레코드 이름, value: {name, type, ttl, records} 또는 {name, type, alias})"
  type = map(object({
    name    = string
    type    = string
    ttl     = optional(number)
    records = optional(list(string))
    alias = optional(object({
      name                   = string
      zone_id                = string
      evaluate_target_health = optional(bool, false)
    }))
  }))
  default = {}
}

variable "tags" {
  description = "추가 태그"
  type        = map(string)
  default     = {}
}

