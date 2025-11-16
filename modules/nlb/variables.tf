# NLB 모듈 변수 정의

variable "project_name" {
  description = "프로젝트 이름"
  type        = string
}

variable "environment" {
  description = "환경 (dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "서브넷 ID 목록"
  type        = list(string)
}

variable "internal" {
  description = "내부 로드 밸런서 여부"
  type        = bool
  default     = true
}

variable "enable_deletion_protection" {
  description = "삭제 보호 활성화 여부"
  type        = bool
  default     = false
}

variable "enable_cross_zone_load_balancing" {
  description = "Cross-Zone 로드 밸런싱 활성화 여부"
  type        = bool
  default     = true
}

variable "listener_port" {
  description = "리스너 포트"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "리스너 프로토콜"
  type        = string
  default     = "TCP"
}

variable "target_port" {
  description = "타겟 포트"
  type        = number
  default     = 80
}

variable "target_protocol" {
  description = "타겟 프로토콜"
  type        = string
  default     = "TCP"
}

variable "health_check_protocol" {
  description = "헬스 체크 프로토콜"
  type        = string
  default     = "TCP"
}

variable "health_check_port" {
  description = "헬스 체크 포트"
  type        = string
  default     = "traffic-port"
}

variable "health_check_path" {
  description = "헬스 체크 경로 (HTTP/HTTPS인 경우)"
  type        = string
  default     = "/"
}

variable "health_check_interval" {
  description = "헬스 체크 간격 (초)"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "헬스 체크 타임아웃 (초)"
  type        = number
  default     = 5
}

variable "health_check_healthy_threshold" {
  description = "헬스 체크 성공 임계값"
  type        = number
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "헬스 체크 실패 임계값"
  type        = number
  default     = 2
}

variable "deregistration_delay" {
  description = "타겟 등록 해제 지연 시간 (초)"
  type        = number
  default     = 300
}

variable "tags" {
  description = "추가 태그"
  type        = map(string)
  default     = {}
}

