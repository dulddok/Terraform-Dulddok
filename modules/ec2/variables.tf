# EC2 모듈 변수 정의

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

variable "ami_id" {
  description = "AMI ID (비워두면 최신 Amazon Linux 2 자동 선택)"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "인스턴스 타입"
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "최소 인스턴스 수"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "최대 인스턴스 수"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "원하는 인스턴스 수"
  type        = number
  default     = 2
}

variable "key_name" {
  description = "기존 키 페어 이름"
  type        = string
  default     = ""
}

variable "create_key_pair" {
  description = "새 키 페어 생성 여부"
  type        = bool
  default     = false
}

variable "public_key" {
  description = "공개 키 내용"
  type        = string
  default     = ""
}

variable "user_data" {
  description = "사용자 데이터 스크립트"
  type        = string
  default     = ""
}

variable "allowed_cidr_blocks" {
  description = "SSH 접근 허용 CIDR 블록"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "target_group_arns" {
  description = "Target Group ARN 목록"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "추가 태그"
  type        = map(string)
  default     = {}
}

variable "alb_security_group_ids" {
  description = "ALB Security Group ID 목록"
  type        = list(string)
  default     = []
}
