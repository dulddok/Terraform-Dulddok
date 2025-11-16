# NLB (Network Load Balancer) 모듈

Network Load Balancer를 생성하는 재사용 가능한 Terraform 모듈입니다.

## 기능

- Network Load Balancer 생성
- Target Group 생성 및 구성
- Listener 설정
- Cross-Zone 로드 밸런싱 지원
- Health Check 구성

## 사용 예시

```hcl
module "nlb" {
  source = "../../modules/nlb"

  project_name   = "my-project"
  environment    = "dev"
  vpc_id         = "vpc-12345678"
  subnet_ids     = ["subnet-123", "subnet-456"]
  internal       = true
  listener_port  = 80
  target_port    = 80

  enable_cross_zone_load_balancing = true

  tags = {
    Environment = "dev"
  }
}
```

## 입력 변수

| 변수명 | 설명 | 타입 | 기본값 | 필수 |
|--------|------|------|--------|------|
| project_name | 프로젝트 이름 | string | - | ✅ |
| environment | 환경 (dev, staging, prod) | string | - | ✅ |
| vpc_id | VPC ID | string | - | ✅ |
| subnet_ids | 서브넷 ID 목록 | list(string) | - | ✅ |
| internal | 내부 로드 밸런서 여부 | bool | true | ❌ |
| enable_cross_zone_load_balancing | Cross-Zone 로드 밸런싱 | bool | true | ❌ |
| listener_port | 리스너 포트 | number | 80 | ❌ |
| target_port | 타겟 포트 | number | 80 | ❌ |

## 출력값

| 출력명 | 설명 |
|--------|------|
| nlb_id | Network Load Balancer ID |
| nlb_arn | Network Load Balancer ARN |
| nlb_dns_name | Network Load Balancer DNS 이름 |
| nlb_zone_id | Network Load Balancer Zone ID (Route53 ALIAS용) |
| target_group_arn | Target Group ARN |

## 참고사항

- PrivateLink 서비스 제공에 사용할 경우 `internal = true`로 설정해야 합니다
- Cross-Zone 로드 밸런싱을 비활성화하면 Cross-AZ 비용을 절감할 수 있습니다

