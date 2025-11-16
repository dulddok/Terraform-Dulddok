# IAM 모듈
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# IAM 역할
resource "aws_iam_role" "main" {
  count = var.create_role ? 1 : 0

  name = "${var.project_name}-${var.environment}-${var.role_name}"

  assume_role_policy = var.assume_role_policy

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-${var.role_name}"
  })
}

# IAM 정책
resource "aws_iam_policy" "main" {
  count = var.create_policy ? 1 : 0

  name        = "${var.project_name}-${var.environment}-${var.policy_name}"
  description = var.policy_description
  policy      = var.policy_document

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-${var.policy_name}"
  })
}

# IAM 역할에 정책 연결
resource "aws_iam_role_policy_attachment" "main" {
  count = var.create_role && var.create_policy ? 1 : 0

  role       = aws_iam_role.main[0].name
  policy_arn = aws_iam_policy.main[0].arn
}

# IAM 사용자
resource "aws_iam_user" "main" {
  count = var.create_user ? 1 : 0

  name = "${var.project_name}-${var.environment}-${var.user_name}"

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-${var.user_name}"
  })
}

# IAM 사용자에 정책 연결
resource "aws_iam_user_policy_attachment" "main" {
  count = var.create_user && var.create_policy ? 1 : 0

  user       = aws_iam_user.main[0].name
  policy_arn = aws_iam_policy.main[0].arn
}

# IAM 액세스 키
resource "aws_iam_access_key" "main" {
  count = var.create_user && var.create_access_key ? 1 : 0

  user = aws_iam_user.main[0].name
}

# IAM 인스턴스 프로파일
resource "aws_iam_instance_profile" "main" {
  count = var.create_instance_profile ? 1 : 0

  name = "${var.project_name}-${var.environment}-${var.instance_profile_name}"
  role = var.create_role ? aws_iam_role.main[0].name : var.existing_role_name

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-${var.instance_profile_name}"
  })
}

