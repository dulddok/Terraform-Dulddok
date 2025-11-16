# Route53 Private Hosted Zone 모듈 출력값 정의

output "zone_id" {
  description = "Private Hosted Zone ID"
  value       = aws_route53_zone.private.zone_id
}

output "zone_name" {
  description = "Private Hosted Zone 이름"
  value       = aws_route53_zone.private.name
}

output "name_servers" {
  description = "Private Hosted Zone Name Servers"
  value       = aws_route53_zone.private.name_servers
}

