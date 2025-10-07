# VPC 모듈 출력값 정의

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "VPC CIDR 블록"
  value       = aws_vpc.main.cidr_block
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.main.id
}

output "public_subnet_ids" {
  description = "Public 서브넷 ID 목록"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private 서브넷 ID 목록"
  value       = aws_subnet.private[*].id
}

output "public_subnet_cidrs" {
  description = "Public 서브넷 CIDR 블록 목록"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_cidrs" {
  description = "Private 서브넷 CIDR 블록 목록"
  value       = aws_subnet.private[*].cidr_block
}

output "nat_gateway_ids" {
  description = "NAT Gateway ID 목록"
  value       = var.enable_nat_gateway ? aws_nat_gateway.main[*].id : []
}

output "public_route_table_id" {
  description = "Public Route Table ID"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "Private Route Table ID 목록"
  value       = aws_route_table.private[*].id
}
