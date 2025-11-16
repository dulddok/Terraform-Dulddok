# PrivateLink 소비자 출력값 정의

output "vpc_endpoint_id" {
  description = "VPC Endpoint ID"
  value       = module.vpc_endpoint.vpc_endpoint_id
}

output "vpc_endpoint_dns_entries" {
  description = "VPC Endpoint DNS 엔트리 (AZ별)"
  value       = module.vpc_endpoint.vpc_endpoint_dns_entries
}

output "vpc_endpoint_state" {
  description = "VPC Endpoint 상태"
  value       = module.vpc_endpoint.vpc_endpoint_state
}

output "route53_zone_id" {
  description = "Route53 Private Hosted Zone ID"
  value       = module.route53_private_zone.zone_id
}

output "client_instance_ids" {
  description = "클라이언트 EC2 인스턴스 ID 목록"
  value       = aws_instance.client_instances[*].id
}

output "az_local_dns_enabled" {
  description = "AZ별 로컬 DNS 사용 여부"
  value       = var.use_az_local_dns
}

output "dns_service_names" {
  description = "사용 가능한 DNS 서비스 이름"
  value = var.use_az_local_dns ? {
    for idx, az in data.aws_subnet.private_subnets[*].availability_zone :
    az => "${var.dns_service_name}-${replace(az, "-", "")}"
  } : {
    "default" = var.dns_service_name
  }
}

output "test_command" {
  description = "PrivateLink 연결 테스트 명령어"
  value       = var.use_az_local_dns ? "ssh to client instance and run: curl http://<AZ-SHORT-DNS>" : "ssh to client instance and run: curl http://${var.dns_service_name}"
}
