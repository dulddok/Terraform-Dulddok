# Security Groups 모듈 변수 정의

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

variable "create_web_sg" {
  description = "웹 서버 보안 그룹 생성 여부"
  type        = bool
  default     = true
}

variable "create_db_sg" {
  description = "데이터베이스 보안 그룹 생성 여부"
  type        = bool
  default     = true
}

variable "create_redis_sg" {
  description = "Redis 보안 그룹 생성 여부"
  type        = bool
  default     = false
}

variable "create_alb_sg" {
  description = "ALB 보안 그룹 생성 여부"
  type        = bool
  default     = false
}

variable "web_ingress_cidr_blocks" {
  description = "웹 서버 인그레스 CIDR 블록"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ssh_ingress_cidr_blocks" {
  description = "SSH 인그레스 CIDR 블록"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "alb_ingress_cidr_blocks" {
  description = "ALB 인그레스 CIDR 블록"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "db_ingress_security_groups" {
  description = "데이터베이스 인그레스 보안 그룹 ID 목록"
  type        = list(string)
  default     = []
}

variable "redis_ingress_security_groups" {
  description = "Redis 인그레스 보안 그룹 ID 목록"
  type        = list(string)
  default     = []
}

variable "allow_ssh" {
  description = "SSH 접근 허용 여부"
  type        = bool
  default     = true
}

variable "db_port" {
  description = "데이터베이스 포트"
  type        = number
  default     = 3306
}

variable "redis_port" {
  description = "Redis 포트"
  type        = number
  default     = 6379
}

variable "tags" {
  description = "추가 태그"
  type        = map(string)
  default     = {}
}

