# IAM 모듈 출력값 정의

output "role_id" {
  description = "IAM 역할 ID"
  value       = var.create_role ? aws_iam_role.main[0].id : null
}

output "role_arn" {
  description = "IAM 역할 ARN"
  value       = var.create_role ? aws_iam_role.main[0].arn : null
}

output "role_name" {
  description = "IAM 역할 이름"
  value       = var.create_role ? aws_iam_role.main[0].name : null
}

output "policy_id" {
  description = "IAM 정책 ID"
  value       = var.create_policy ? aws_iam_policy.main[0].id : null
}

output "policy_arn" {
  description = "IAM 정책 ARN"
  value       = var.create_policy ? aws_iam_policy.main[0].arn : null
}

output "policy_name" {
  description = "IAM 정책 이름"
  value       = var.create_policy ? aws_iam_policy.main[0].name : null
}

output "user_id" {
  description = "IAM 사용자 ID"
  value       = var.create_user ? aws_iam_user.main[0].id : null
}

output "user_arn" {
  description = "IAM 사용자 ARN"
  value       = var.create_user ? aws_iam_user.main[0].arn : null
}

output "user_name" {
  description = "IAM 사용자 이름"
  value       = var.create_user ? aws_iam_user.main[0].name : null
}

output "access_key_id" {
  description = "IAM 액세스 키 ID"
  value       = var.create_user && var.create_access_key ? aws_iam_access_key.main[0].id : null
}

output "secret_access_key" {
  description = "IAM 시크릿 액세스 키"
  value       = var.create_user && var.create_access_key ? aws_iam_access_key.main[0].secret : null
  sensitive   = true
}

output "instance_profile_id" {
  description = "IAM 인스턴스 프로파일 ID"
  value       = var.create_instance_profile ? aws_iam_instance_profile.main[0].id : null
}

output "instance_profile_arn" {
  description = "IAM 인스턴스 프로파일 ARN"
  value       = var.create_instance_profile ? aws_iam_instance_profile.main[0].arn : null
}

output "instance_profile_name" {
  description = "IAM 인스턴스 프로파일 이름"
  value       = var.create_instance_profile ? aws_iam_instance_profile.main[0].name : null
}

