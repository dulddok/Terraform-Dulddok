# Security Groups 모듈 출력값 정의

output "web_security_group_id" {
  description = "웹 서버 보안 그룹 ID"
  value       = var.create_web_sg ? aws_security_group.web[0].id : null
}

output "web_security_group_arn" {
  description = "웹 서버 보안 그룹 ARN"
  value       = var.create_web_sg ? aws_security_group.web[0].arn : null
}

output "database_security_group_id" {
  description = "데이터베이스 보안 그룹 ID"
  value       = var.create_db_sg ? aws_security_group.database[0].id : null
}

output "database_security_group_arn" {
  description = "데이터베이스 보안 그룹 ARN"
  value       = var.create_db_sg ? aws_security_group.database[0].arn : null
}

output "redis_security_group_id" {
  description = "Redis 보안 그룹 ID"
  value       = var.create_redis_sg ? aws_security_group.redis[0].id : null
}

output "redis_security_group_arn" {
  description = "Redis 보안 그룹 ARN"
  value       = var.create_redis_sg ? aws_security_group.redis[0].arn : null
}

output "alb_security_group_id" {
  description = "ALB 보안 그룹 ID"
  value       = var.create_alb_sg ? aws_security_group.alb[0].id : null
}

output "alb_security_group_arn" {
  description = "ALB 보안 그룹 ARN"
  value       = var.create_alb_sg ? aws_security_group.alb[0].arn : null
}

