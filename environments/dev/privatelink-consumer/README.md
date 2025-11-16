# PrivateLink 소비자 구성

이 디렉터리는 PrivateLink 서비스를 사용하는 소비자(Consumer) 측 구성을 포함합니다.

## 구성 요소

1. **VPC Endpoint**: PrivateLink 서비스에 연결하기 위한 Interface 엔드포인트
2. **Route53 Private Hosted Zone**: VPC Endpoint DNS를 사용한 Local DNS 설정
3. **EC2 클라이언트 인스턴스**: 각 AZ에 배치된 테스트용 클라이언트 인스턴스

## 배포 순서

1. Networking 서비스 배포
2. PrivateLink 서비스 배포 (제공자)
3. PrivateLink 소비자 배포 (이 디렉터리)

## 사용 방법

```bash
# 백엔드 초기화 (최초 1회)
cd environments/dev/privatelink-consumer
terraform init -backend-config=backend.hcl

# 설정 파일 복사
cp terraform.tfvars.example terraform.tfvars
# terraform.tfvars 파일을 수정하여 실제 값 입력
# 특히 privatelink_key가 올바른지 확인

# 계획 확인
terraform plan

# 배포
terraform apply
```

## 연결 테스트

배포 후 클라이언트 인스턴스에 SSH 접속하여 PrivateLink 연결을 테스트할 수 있습니다:

```bash
# 클라이언트 인스턴스에 SSH 접속
ssh -i your-key.pem ec2-user@<client-instance-ip>

# AZ별 로컬 DNS가 활성화된 경우 (use_az_local_dns = true)
# 각 AZ의 인스턴스는 자동으로 같은 AZ의 ENI를 사용
./test-privatelink.sh

# 또는 직접 호출 (AZ별 DNS)
curl http://service.privatelink.local-apnortheast2a  # ap-northeast-2a의 경우
curl http://service.privatelink.local-apnortheast2c  # ap-northeast-2c의 경우

# 기본 DNS 사용 (use_az_local_dns = false)
curl http://service.privatelink.local
```

## AZ별 로컬 DNS (비용 최적화)

`use_az_local_dns = true`로 설정하면:
- 각 AZ별로 별도의 DNS 레코드가 생성됩니다
- 각 인스턴스는 자신의 AZ에 해당하는 DNS 레코드를 사용합니다
- **같은 AZ 내의 ENI만 사용**하므로 **Cross-AZ 데이터 전송 비용이 발생하지 않습니다**

예시:
- `service.privatelink.local-apnortheast2a` → ap-northeast-2a의 VPC Endpoint ENI
- `service.privatelink.local-apnortheast2c` → ap-northeast-2c의 VPC Endpoint ENI

이 설정을 통해 Cross-AZ 트래픽 비용을 절감할 수 있습니다.

## 주의사항

- PrivateLink 서비스 제공자가 `acceptance_required=true`로 설정한 경우, 제공자 측에서 연결을 수동으로 승인해야 합니다
- VPC Endpoint가 생성되면 각 AZ에 Network Interface가 생성됩니다 (비용 발생)
- Route53 Private Hosted Zone은 VPC Endpoint DNS를 사용하여 서비스를 찾을 수 있게 합니다

