# EC2 모듈 출력값 정의

output "security_group_id" {
  description = "EC2 Security Group ID"
  value       = aws_security_group.ec2.id
}

output "launch_template_id" {
  description = "Launch Template ID"
  value       = aws_launch_template.main.id
}

output "autoscaling_group_id" {
  description = "Auto Scaling Group ID"
  value       = aws_autoscaling_group.main.id
}

output "autoscaling_group_name" {
  description = "Auto Scaling Group 이름"
  value       = aws_autoscaling_group.main.name
}

output "autoscaling_group_arn" {
  description = "Auto Scaling Group ARN"
  value       = aws_autoscaling_group.main.arn
}

output "key_pair_name" {
  description = "Key Pair 이름"
  value       = var.create_key_pair ? aws_key_pair.main[0].key_name : var.key_name
}
