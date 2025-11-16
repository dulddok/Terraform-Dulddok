# Networking 서비스 출력값 정의

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR 블록"
  value       = module.vpc.vpc_cidr_block
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = module.vpc.internet_gateway_id
}

output "public_subnet_ids" {
  description = "Public 서브넷 ID 목록"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private 서브넷 ID 목록"
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_cidrs" {
  description = "Public 서브넷 CIDR 블록 목록"
  value       = module.vpc.public_subnet_cidrs
}

output "private_subnet_cidrs" {
  description = "Private 서브넷 CIDR 블록 목록"
  value       = module.vpc.private_subnet_cidrs
}

output "nat_gateway_ids" {
  description = "NAT Gateway ID 목록"
  value       = module.vpc.nat_gateway_ids
}

output "public_route_table_id" {
  description = "Public Route Table ID"
  value       = module.vpc.public_route_table_id
}

output "private_route_table_ids" {
  description = "Private Route Table ID 목록"
  value       = module.vpc.private_route_table_ids
}

output "private_subnet_availability_zones" {
  description = "Private 서브넷의 가용 영역 목록"
  value       = module.vpc.private_subnet_availability_zones
}

output "availability_zones" {
  description = "사용된 가용 영역 목록"
  value       = module.vpc.availability_zones
}

