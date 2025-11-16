# PrivateLink + Local DNS + Cross-AZ 비용 테스트 가이드

이 문서는 Terraform을 사용하여 AWS PrivateLink, Local DNS (Route53 Private Hosted Zone), 그리고 Cross-AZ 비용 테스트 인프라를 구성하는 방법을 설명합니다.

## 개요

### 구성 요소

1. **PrivateLink 서비스 제공자 (Provider)**
   - Network Load Balancer (NLB)
   - EC2 인스턴스 (각 AZ에 배치)
   - VPC Endpoint Service

2. **PrivateLink 서비스 소비자 (Consumer)**
   - VPC Endpoint (Interface 타입)
   - Route53 Private Hosted Zone (Local DNS)

3. **Cross-AZ 비용 테스트**
   - Cross-Zone 로드 밸런싱 설정으로 테스트 가능
   - 각 AZ에 배치된 인스턴스 간 트래픽 모니터링

## 아키텍처

```
┌─────────────────────────────────────────────────────────┐
│  PrivateLink 서비스 제공자 (Provider)                   │
│                                                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐            │
│  │ EC2 (AZ1)│  │ EC2 (AZ2)│  │ EC2 (AZ3)│            │
│  └────┬─────┘  └────┬───────┘  └────┬─────┘            │
│       │           │                 │                   │
│       └───────────┼─────────────────┘                   │
│                   │                                     │
│            ┌──────▼──────┐                             │
│            │  NLB        │                             │
│            │  (Internal) │                             │
│            └──────┬──────┘                             │
│                   │                                     │
│            ┌──────▼──────┐                             │
│            │ VPC Endpoint│                             │
│            │ Service     │                             │
│            └─────────────┘                             │
└─────────────────────────────────────────────────────────┘
                        │
                        │ PrivateLink Connection
                        │
┌───────────────────────▼─────────────────────────────────┐
│  PrivateLink 서비스 소비자 (Consumer)                   │
│                                                         │
│  ┌──────────────┐                                       │
│  │ VPC Endpoint │                                       │
│  │ (Interface)  │                                       │
│  └──────┬───────┘                                       │
│         │                                               │
│  ┌──────▼──────────┐                                    │
│  │ Route53 Private│                                    │
│  │ Hosted Zone    │                                    │
│  └──────┬─────────┘                                    │
│         │                                               │
│  ┌──────▼──────┐  ┌──────┐  ┌──────┐                  │
│  │Client (AZ1) │  │Client│  │Client│                  │
│  │             │  │(AZ2) │  │(AZ3) │                  │
│  └─────────────┘  └──────┘  └──────┘                  │
└─────────────────────────────────────────────────────────┘
```

## 배포 순서

### 1. 사전 요구사항

- Networking 서비스가 이미 배포되어 있어야 합니다
- Terraform 백엔드 (S3 + DynamoDB)가 구성되어 있어야 합니다

### 2. PrivateLink 서비스 제공자 배포

```bash
cd environments/dev/privatelink

# 백엔드 설정 (최초만)
cp backend.hcl.example backend.hcl
# backend.hcl 파일을 실제 값으로 수정

# 변수 설정
cp terraform.tfvars.example terraform.tfvars
# terraform.tfvars 파일을 수정하여 실제 값 입력

# 초기화 및 배포
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

### 3. PrivateLink 서비스 소비자 배포

```bash
cd environments/dev/privatelink-consumer

# 백엔드 설정
cp backend.hcl.example backend.hcl
# backend.hcl 파일을 실제 값으로 수정

# 변수 설정
cp terraform.tfvars.example terraform.tfvars
# terraform.tfvars 파일을 수정하여 실제 값 입력
# 특히 privatelink_key가 올바른지 확인

# 초기화 및 배포
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

### 4. 연결 승인 (필요한 경우)

PrivateLink 서비스에서 `acceptance_required = true`로 설정한 경우:

1. AWS 콘솔에서 VPC > Endpoint Services > 해당 서비스 선택
2. Endpoint connections 탭에서 보류 중인 연결 확인
3. 연결 승인

또는 Terraform으로 자동 승인하려면:

```hcl
# PrivateLink 서비스 제공자의 terraform.tfvars에서
auto_accept_principals = [
  "arn:aws:iam::ACCOUNT_ID:root"  # 소비자 계정 ARN
]
```

## Cross-AZ 비용 테스트

### 설정

PrivateLink 서비스 제공자의 `terraform.tfvars`에서:

```hcl
# Cross-Zone 로드 밸런싱 활성화 (Cross-AZ 트래픽 발생)
enable_cross_zone_load_balancing = true

# 또는 비활성화 (같은 AZ 내에서만 트래픽 분산)
enable_cross_zone_load_balancing = false
```

### 테스트 방법

1. **CloudWatch 메트릭 모니터링**
   - NLB 메트릭: `ProcessedBytes`, `ActiveFlowCount`
   - VPC Endpoint 메트릭: `BytesIn`, `BytesOut`

2. **비용 분석**
   - Cross-AZ 데이터 전송: GB당 요금 발생
   - 같은 AZ 내 통신: 요금 없음

3. **실제 테스트**
   ```bash
   # 클라이언트 인스턴스에 SSH 접속
   ssh ec2-user@<client-instance-ip>
   
   # PrivateLink 서비스에 연결 테스트
   curl http://service.privatelink.local
   
   # 네트워크 트래픽 모니터링
   # CloudWatch에서 VPC Endpoint 메트릭 확인
   ```

## Local DNS 설정

Route53 Private Hosted Zone을 통해 VPC 내에서 PrivateLink 서비스를 DNS 이름으로 접근할 수 있습니다.

### DNS 설정

1. **PrivateLink 서비스 제공자 측**
   - Route53 Private Hosted Zone 생성
   - 서비스 이름: `service.privatelink.local` (예시)

2. **PrivateLink 서비스 소비자 측**
   - 같은 VPC에 Route53 Private Hosted Zone 연결
   - VPC Endpoint DNS를 사용하여 레코드 생성

### AZ별 로컬 DNS (비용 최적화) ⭐

**중요**: `use_az_local_dns = true`로 설정하면 Cross-AZ 데이터 전송 비용을 절감할 수 있습니다.

- **활성화 시**: 각 AZ별로 별도의 DNS 레코드 생성
  - `service.privatelink.local-apnortheast2a` → ap-northeast-2a의 ENI
  - `service.privatelink.local-apnortheast2c` → ap-northeast-2c의 ENI
  - 각 인스턴스는 자신의 AZ에 해당하는 DNS를 사용하여 **같은 AZ의 ENI만 호출**
  - **Cross-AZ 데이터 전송 비용 없음** ✅

- **비활성화 시**: 모든 AZ의 ENI를 하나의 DNS 레코드에 포함
  - `service.privatelink.local` → 모든 AZ의 ENI
  - 클라이언트가 자동으로 가까운 ENI 선택 (하지만 Cross-AZ 트래픽 가능)

### DNS 확인

```bash
# VPC 내 인스턴스에서

# AZ별 로컬 DNS 사용 시
nslookup service.privatelink.local-apnortheast2a  # 자신의 AZ 확인
dig service.privatelink.local-apnortheast2a

# 기본 DNS 사용 시
nslookup service.privatelink.local
dig service.privatelink.local
```

## 주요 모듈

### modules/nlb
Network Load Balancer 모듈
- PrivateLink 서비스 제공에 필수
- Cross-Zone 로드 밸런싱 설정 지원

### modules/privatelink-service
VPC Endpoint Service 모듈
- PrivateLink 서비스 정의
- 연결 승인 정책 설정

### modules/vpc-endpoint
VPC Endpoint 모듈
- Interface 타입 엔드포인트
- PrivateLink 서비스 소비

### modules/route53-private-zone
Route53 Private Hosted Zone 모듈
- VPC 내부 DNS 설정
- ALIAS 및 A 레코드 지원

## 비용 고려사항

1. **VPC Endpoint**
   - 시간당 요금 (Interface 엔드포인트)
   - 데이터 처리 요금 (GB당)
   - 각 AZ마다 Network Interface 생성 (최소 3개)

2. **Cross-AZ 데이터 전송**
   - 같은 AZ 내: 무료
   - 다른 AZ 간: GB당 요금 발생
   - Cross-Zone 로드 밸런싱 활성화 시 비용 증가 가능

3. **Network Load Balancer**
   - 시간당 요금
   - 처리된 데이터 요금

## 문제 해결

### 연결 실패
- VPC Endpoint Service 연결이 승인되었는지 확인
- Security Group 규칙 확인
- Route53 DNS 설정 확인

### DNS 해석 실패
- Private Hosted Zone이 VPC에 연결되어 있는지 확인
- VPC Endpoint의 `private_dns_enabled` 설정 확인

### Cross-AZ 비용이 예상과 다른 경우
- CloudWatch 메트릭으로 실제 트래픽 패턴 확인
- NLB의 Cross-Zone 로드 밸런싱 설정 확인
- 각 AZ의 인스턴스 상태 확인

## 참고 자료

- [AWS PrivateLink 문서](https://docs.aws.amazon.com/vpc/latest/privatelink/)
- [VPC Endpoint Service 가이드](https://docs.aws.amazon.com/vpc/latest/privatelink/create-endpoint-service.html)
- [Route53 Private Hosted Zones](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-private.html)

