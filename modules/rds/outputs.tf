# RDS 모듈 출력값 정의

output "db_instance_id" {
  description = "RDS 인스턴스 ID"
  value       = aws_db_instance.main.id
}

output "db_instance_arn" {
  description = "RDS 인스턴스 ARN"
  value       = aws_db_instance.main.arn
}

output "db_instance_endpoint" {
  description = "RDS 인스턴스 엔드포인트"
  value       = aws_db_instance.main.endpoint
}

output "db_instance_address" {
  description = "RDS 인스턴스 주소"
  value       = aws_db_instance.main.address
}

output "db_instance_port" {
  description = "RDS 인스턴스 포트"
  value       = aws_db_instance.main.port
}

output "db_instance_name" {
  description = "RDS 인스턴스 이름"
  value       = aws_db_instance.main.db_name
}

output "db_instance_username" {
  description = "RDS 인스턴스 사용자 이름"
  value       = aws_db_instance.main.username
}

output "security_group_id" {
  description = "RDS 보안 그룹 ID"
  value       = aws_security_group.rds.id
}

output "subnet_group_name" {
  description = "DB 서브넷 그룹 이름"
  value       = aws_db_subnet_group.main.name
}

