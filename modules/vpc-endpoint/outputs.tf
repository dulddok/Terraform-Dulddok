# VPC Endpoint 모듈 출력값 정의

output "vpc_endpoint_id" {
  description = "VPC Endpoint ID"
  value       = aws_vpc_endpoint.this.id
}

output "vpc_endpoint_arn" {
  description = "VPC Endpoint ARN"
  value       = aws_vpc_endpoint.this.arn
}

output "vpc_endpoint_dns_entries" {
  description = "VPC Endpoint DNS 엔트리"
  value       = aws_vpc_endpoint.this.dns_entry
}

output "vpc_endpoint_network_interface_ids" {
  description = "VPC Endpoint Network Interface ID 목록"
  value       = aws_vpc_endpoint.this.network_interface_ids
}

output "vpc_endpoint_state" {
  description = "VPC Endpoint 상태"
  value       = aws_vpc_endpoint.this.state
}

