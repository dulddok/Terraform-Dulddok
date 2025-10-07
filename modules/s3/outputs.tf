# S3 모듈 출력값 정의

output "bucket_id" {
  description = "S3 버킷 ID"
  value       = aws_s3_bucket.main.id
}

output "bucket_arn" {
  description = "S3 버킷 ARN"
  value       = aws_s3_bucket.main.arn
}

output "bucket_domain_name" {
  description = "S3 버킷 도메인 이름"
  value       = aws_s3_bucket.main.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "S3 버킷 지역 도메인 이름"
  value       = aws_s3_bucket.main.bucket_regional_domain_name
}

output "bucket_website_endpoint" {
  description = "S3 버킷 웹사이트 엔드포인트"
  value       = aws_s3_bucket.main.website_endpoint
}

output "bucket_website_domain" {
  description = "S3 버킷 웹사이트 도메인"
  value       = aws_s3_bucket.main.website_domain
}

