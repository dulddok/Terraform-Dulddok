# PrivateLink 서비스 변수 정의

variable "project_name" {
  description = "프로젝트 이름"
  type        = string
  default     = "my-project"
}

variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "environment" {
  description = "환경"
  type        = string
  default     = "dev"
}

variable "backend_config" {
  description = "Terraform 백엔드 설정"
  type = object({
    bucket         = string
    networking_key = string
    dynamodb_table = string
  })
  default = {
    bucket         = ""
    networking_key = "environments/dev/networking/terraform.tfstate"
    dynamodb_table = ""
  }
}

variable "instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID (비워두면 최신 Amazon Linux 2 자동 선택)"
  type        = string
  default     = ""
}

variable "acceptance_required" {
  description = "PrivateLink 연결 승인 필요 여부"
  type        = bool
  default     = false
}

variable "allowed_principals" {
  description = "허용된 AWS 계정/역할 ARN 목록"
  type        = list(string)
  default     = []
}

variable "auto_accept_principals" {
  description = "자동 승인할 AWS 계정/역할 ARN 목록"
  type        = list(string)
  default     = []
}

variable "enable_cross_zone_load_balancing" {
  description = "Cross-Zone 로드 밸런싱 활성화 여부 (Cross-AZ 비용 테스트)"
  type        = bool
  default     = true
}

variable "dns_zone_name" {
  description = "Private Hosted Zone 이름"
  type        = string
  default     = "privatelink.local"
}

variable "dns_service_name" {
  description = "DNS 서비스 이름 (FQDN: service.zone_name)"
  type        = string
  default     = "service.privatelink.local"
}

