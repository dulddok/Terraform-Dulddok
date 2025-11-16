# PrivateLink 소비자 변수 정의

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
    bucket          = string
    networking_key  = string
    privatelink_key = string
    dynamodb_table  = string
  })
  default = {
    bucket          = ""
    networking_key  = "environments/dev/networking/terraform.tfstate"
    privatelink_key = "environments/dev/privatelink/terraform.tfstate"
    dynamodb_table  = ""
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

variable "auto_accept" {
  description = "VPC Endpoint 연결 자동 승인 여부"
  type        = bool
  default     = false
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

variable "use_az_local_dns" {
  description = "AZ별 로컬 DNS 사용 여부 (같은 AZ의 ENI 사용하여 Cross-AZ 비용 최소화)"
  type        = bool
  default     = true
}

