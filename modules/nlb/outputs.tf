# NLB 모듈 출력값 정의

output "nlb_id" {
  description = "Network Load Balancer ID"
  value       = aws_lb.nlb.id
}

output "nlb_arn" {
  description = "Network Load Balancer ARN"
  value       = aws_lb.nlb.arn
}

output "nlb_dns_name" {
  description = "Network Load Balancer DNS 이름"
  value       = aws_lb.nlb.dns_name
}

output "target_group_arn" {
  description = "Target Group ARN"
  value       = aws_lb_target_group.nlb.arn
}

output "target_group_id" {
  description = "Target Group ID"
  value       = aws_lb_target_group.nlb.id
}

output "listener_arn" {
  description = "Listener ARN"
  value       = aws_lb_listener.nlb.arn
}

output "nlb_zone_id" {
  description = "Network Load Balancer Zone ID (Route53 ALIAS용)"
  value       = aws_lb.nlb.zone_id
}

