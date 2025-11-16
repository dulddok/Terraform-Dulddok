# PrivateLink 서비스 구성

이 디렉터리는 PrivateLink 서비스 제공자(Provider) 측 구성을 포함합니다.

## 구성 요소

1. **Network Load Balancer (NLB)**: PrivateLink 서비스를 제공하기 위한 내부 NLB
2. **EC2 인스턴스**: 각 AZ에 배치된 서비스 제공 인스턴스
3. **VPC Endpoint Service**: PrivateLink 서비스 정의
4. **Route53 Private Hosted Zone**: Local DNS 설정

## Cross-AZ 비용 테스트

`enable_cross_zone_load_balancing` 변수를 통해 Cross-Zone 로드 밸런싱을 활성화/비활성화하여 Cross-AZ 트래픽 비용을 테스트할 수 있습니다.

- `true`: 모든 AZ의 타겟으로 트래픽 분산 (Cross-AZ 트래픽 발생)
- `false`: 같은 AZ의 타겟으로만 트래픽 분산 (Cross-AZ 트래픽 최소화)

## 배포 순서

1. Networking 서비스 배포
2. PrivateLink 서비스 배포
3. (선택) PrivateLink 소비자 배포

## 사용 방법

```bash
# 백엔드 초기화 (최초 1회)
cd environments/dev/privatelink
terraform init -backend-config=backend.hcl

# 설정 파일 복사
cp terraform.tfvars.example terraform.tfvars
# terraform.tfvars 파일을 수정하여 실제 값 입력

# 계획 확인
terraform plan

# 배포
terraform apply
```

## 출력값

- `vpc_endpoint_service_name`: 다른 VPC에서 연결할 때 사용하는 서비스 이름
- `nlb_dns_name`: NLB DNS 이름
- `route53_zone_id`: Private Hosted Zone ID

## 주의사항

- PrivateLink 서비스는 Network Load Balancer만 지원합니다 (ALB는 불가)
- `acceptance_required=true`로 설정하면 소비자 측에서 연결을 요청하면 제공자 측에서 수동으로 승인해야 합니다
- AWS 콘솔에서 VPC Endpoint Service Connections를 확인하여 연결 요청을 승인할 수 있습니다

