# Compute 서비스 변수 정의

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

variable "instance_type" {
  description = "EC2 인스턴스 타입"
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
  default     = 2
}

variable "desired_capacity" {
  description = "원하는 인스턴스 수"
  type        = number
  default     = 1
}

variable "user_data" {
  description = "EC2 사용자 데이터 스크립트"
  type        = string
  default     = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello from $(hostname) in $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</h1>" > /var/www/html/index.html
  EOF
}

variable "remote_state_bucket" {
  description = "네트워킹 스택 상태가 저장된 S3 버킷명"
  type        = string
}

