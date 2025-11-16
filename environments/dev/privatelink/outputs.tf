# PrivateLink 서비스 출력값 정의

output "vpc_endpoint_service_id" {
  description = "VPC Endpoint Service ID"
  value       = module.privatelink_service.vpc_endpoint_service_id
}

output "vpc_endpoint_service_name" {
  description = "VPC Endpoint Service 이름"
  value       = module.privatelink_service.vpc_endpoint_service_name
}

output "vpc_endpoint_service_arn" {
  description = "VPC Endpoint Service ARN"
  value       = module.privatelink_service.vpc_endpoint_service_arn
}

output "nlb_dns_name" {
  description = "Network Load Balancer DNS 이름"
  value       = module.nlb.nlb_dns_name
}

output "nlb_arn" {
  description = "Network Load Balancer ARN"
  value       = module.nlb.nlb_arn
}

output "service_instance_ids" {
  description = "서비스 제공 EC2 인스턴스 ID 목록"
  value       = aws_instance.service_instances[*].id
}

output "route53_zone_id" {
  description = "Route53 Private Hosted Zone ID"
  value       = module.route53_private_zone.zone_id
}

output "route53_zone_name" {
  description = "Route53 Private Hosted Zone 이름"
  value       = module.route53_private_zone.zone_name
}

output "dns_service_fqdn" {
  description = "DNS 서비스 FQDN"
  value       = var.dns_service_name
}

