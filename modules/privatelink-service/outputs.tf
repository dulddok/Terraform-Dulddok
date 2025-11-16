# PrivateLink Service 모듈 출력값 정의

output "vpc_endpoint_service_id" {
  description = "VPC Endpoint Service ID"
  value       = aws_vpc_endpoint_service.this.id
}

output "vpc_endpoint_service_name" {
  description = "VPC Endpoint Service 이름"
  value       = aws_vpc_endpoint_service.this.service_name
}

output "vpc_endpoint_service_arn" {
  description = "VPC Endpoint Service ARN"
  value       = aws_vpc_endpoint_service.this.arn
}

output "vpc_endpoint_service_dns_name" {
  description = "VPC Endpoint Service DNS 이름"
  value       = aws_vpc_endpoint_service.this.service_name
}

