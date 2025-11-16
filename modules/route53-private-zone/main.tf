# Route53 Private Hosted Zone 모듈
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Route53 Private Hosted Zone 생성
resource "aws_route53_zone" "private" {
  name = var.zone_name

  vpc {
    vpc_id     = var.vpc_id
    vpc_region = var.vpc_region
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-private-zone"
  })
}

# DNS 레코드 생성 (선택적)
resource "aws_route53_record" "records" {
  for_each = var.dns_records

  zone_id = aws_route53_zone.private.zone_id
  name    = each.value.name
  type    = each.value.type

  # ALIAS 타입이 아닌 경우에만 ttl과 records 설정
  ttl     = each.value.alias != null ? null : (each.value.ttl != null ? each.value.ttl : 300)
  records = each.value.alias != null ? null : (each.value.records != null ? each.value.records : [])

  # ALIAS 타입인 경우 alias 블록 사용
  dynamic "alias" {
    for_each = each.value.alias != null ? [each.value.alias] : []
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health != null ? alias.value.evaluate_target_health : false
    }
  }
}

