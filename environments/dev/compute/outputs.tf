# Compute 서비스 출력값 정의

output "security_group_id" {
  description = "EC2 Security Group ID"
  value       = module.ec2.security_group_id
}

output "launch_template_id" {
  description = "Launch Template ID"
  value       = module.ec2.launch_template_id
}

output "autoscaling_group_id" {
  description = "Auto Scaling Group ID"
  value       = module.ec2.autoscaling_group_id
}

output "autoscaling_group_name" {
  description = "Auto Scaling Group 이름"
  value       = module.ec2.autoscaling_group_name
}

output "autoscaling_group_arn" {
  description = "Auto Scaling Group ARN"
  value       = module.ec2.autoscaling_group_arn
}

output "key_pair_name" {
  description = "Key Pair 이름"
  value       = module.ec2.key_pair_name
}

output "alb_dns_name" {
  description = "ALB DNS 이름 (웹 접속용)"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "ALB Zone ID"
  value       = module.alb.alb_zone_id
}

