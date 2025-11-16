# VPC Endpoint 모듈

Interface 타입 VPC Endpoint를 생성하는 재사용 가능한 Terraform 모듈입니다.

## 기능

- Interface 타입 VPC Endpoint 생성
- Private DNS 활성화 지원
- Security Group 연결
- 여러 서브넷(AZ) 지원

## 사용 예시

```hcl
module "vpc_endpoint" {
  source = "../../modules/vpc-endpoint"

  project_name      = "my-project"
  environment       = "dev"
  endpoint_name     = "privatelink-service"
  vpc_id            = "vpc-12345678"
  service_name      = "com.amazonaws.vpce.ap-northeast-2.vpce-svc-12345678"
  subnet_ids        = ["subnet-123", "subnet-456"]
  security_group_ids = ["sg-12345678"]
  private_dns_enabled = true

  tags = {
    Environment = "dev"
  }
}
```

## 입력 변수

| 변수명 | 설명 | 타입 | 기본값 | 필수 |
|--------|------|------|--------|------|
| project_name | 프로젝트 이름 | string | - | ✅ |
| environment | 환경 | string | - | ✅ |
| endpoint_name | 엔드포인트 이름 | string | - | ✅ |
| vpc_id | VPC ID | string | - | ✅ |
| service_name | VPC Endpoint Service 이름 | string | - | ✅ |
| subnet_ids | 서브넷 ID 목록 | list(string) | - | ✅ |
| security_group_ids | Security Group ID 목록 | list(string) | [] | ❌ |
| private_dns_enabled | Private DNS 활성화 | bool | true | ❌ |

## 출력값

| 출력명 | 설명 |
|--------|------|
| vpc_endpoint_id | VPC Endpoint ID |
| vpc_endpoint_arn | VPC Endpoint ARN |
| vpc_endpoint_dns_entries | VPC Endpoint DNS 엔트리 (AZ별) |
| vpc_endpoint_network_interface_ids | Network Interface ID 목록 |
| vpc_endpoint_state | VPC Endpoint 상태 |

## 참고사항

- PrivateLink 서비스 소비에 사용됩니다
- 각 서브넷마다 Network Interface가 생성됩니다 (비용 발생)
- `private_dns_enabled = true`로 설정하면 AWS가 자동으로 DNS를 관리합니다

