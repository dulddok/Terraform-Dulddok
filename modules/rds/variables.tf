# RDS 모듈 변수 정의

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

variable "allowed_security_groups" {
  description = "DB 접근 허용 보안 그룹 ID 목록"
  type        = list(string)
  default     = []
}

variable "engine" {
  description = "DB 엔진"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "DB 엔진 버전"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "DB 인스턴스 클래스"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "할당된 스토리지 크기 (GB)"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "최대 할당 스토리지 크기 (GB)"
  type        = number
  default     = 100
}

variable "storage_type" {
  description = "스토리지 타입"
  type        = string
  default     = "gp2"
}

variable "storage_encrypted" {
  description = "스토리지 암호화 여부"
  type        = bool
  default     = true
}

variable "db_name" {
  description = "데이터베이스 이름"
  type        = string
  default     = "mydb"
}

variable "username" {
  description = "마스터 사용자 이름"
  type        = string
  default     = "admin"
}

variable "password" {
  description = "마스터 사용자 비밀번호"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "데이터베이스 포트"
  type        = number
  default     = 3306
}

variable "backup_retention_period" {
  description = "백업 보존 기간 (일)"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "백업 윈도우"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "유지보수 윈도우"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "skip_final_snapshot" {
  description = "최종 스냅샷 건너뛰기 여부"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "삭제 보호 활성화 여부"
  type        = bool
  default     = true
}

variable "tags" {
  description = "추가 태그"
  type        = map(string)
  default     = {}
}

