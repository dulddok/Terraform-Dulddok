# Terraform AWS 인프라 구성

이 저장소는 Terraform을 사용하여 AWS 인프라를 구성하는 실무용 프로젝트입니다.

## 📁 디렉터리 구조

```
├── environments/           # 환경별 설정
│   ├── dev/               # 개발 환경
│   │   ├── networking/    # 네트워킹 서비스 (VPC, 서브넷 등)
│   │   ├── compute/       # 컴퓨팅 서비스 (EC2, Auto Scaling 등)
│   │   ├── database/      # 데이터베이스 서비스 (RDS 등)
│   │   └── storage/       # 스토리지 서비스 (S3 등)
│   ├── staging/           # 스테이징 환경
│   │   ├── networking/
│   │   ├── compute/
│   │   ├── database/
│   │   └── storage/
│   └── prod/              # 프로덕션 환경
│       ├── networking/
│       ├── compute/
│       ├── database/
│       └── storage/
├── modules/               # 재사용 가능한 모듈
│   ├── vpc/               # VPC 모듈
│   ├── ec2/               # EC2 모듈
│   ├── rds/               # RDS 모듈
│   ├── s3/                # S3 모듈
│   ├── iam/               # IAM 모듈
│   └── security-groups/   # 보안 그룹 모듈
├── scripts/               # 유틸리티 스크립트
├── docs/                  # 문서
└── .github/workflows/     # GitHub Actions
```

## 🚀 시작하기

### 1. 사전 요구사항

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) 설치 및 구성
- AWS 자격 증명 설정

### 2. 백엔드 초기화

```bash
# S3 버킷과 DynamoDB 테이블 생성
./scripts/init-backend.sh ap-northeast-2 my-project
```

### 3. 서비스별 배포

```bash
# 1. 네트워킹 서비스 배포 (먼저 배포해야 함)
./scripts/deploy.sh dev networking plan
./scripts/deploy.sh dev networking apply

# 2. 컴퓨팅 서비스 배포
./scripts/deploy.sh dev compute plan
./scripts/deploy.sh dev compute apply

# 3. 데이터베이스 서비스 배포
./scripts/deploy.sh dev database plan
./scripts/deploy.sh dev database apply

# 4. 스토리지 서비스 배포
./scripts/deploy.sh dev storage plan
./scripts/deploy.sh dev storage apply
```

### 4. 환경별 배포 순서

**개발 환경:**
```bash
# 1. 네트워킹
./scripts/deploy.sh dev networking apply

# 2. 컴퓨팅
./scripts/deploy.sh dev compute apply
```

**스테이징 환경:**
```bash
# 1. 네트워킹
./scripts/deploy.sh staging networking apply

# 2. 컴퓨팅
./scripts/deploy.sh staging compute apply
```

**프로덕션 환경:**
```bash
# 1. 네트워킹
./scripts/deploy.sh prod networking apply

# 2. 컴퓨팅
./scripts/deploy.sh prod compute apply
```

## 🏗️ 모듈 설명

### VPC 모듈
- VPC, 서브넷, 라우트 테이블 생성
- Internet Gateway, NAT Gateway 구성
- 가용 영역별 네트워크 분리

### EC2 모듈
- Auto Scaling Group 구성
- Launch Template 설정
- Security Group 관리
- Key Pair 생성/관리

## 🔧 환경별 설정

각 환경(`dev`, `staging`, `prod`)은 독립적인 설정을 가집니다:

### 개발 환경 (dev)
- **네트워크**: 10.0.0.0/16, 2개 AZ
- **인스턴스**: t3.micro, 최소 1개, 최대 2개
- **목적**: 개발 및 테스트

### 스테이징 환경 (staging)
- **네트워크**: 10.1.0.0/16, 2개 AZ
- **인스턴스**: t3.small, 최소 2개, 최대 4개
- **목적**: 프로덕션과 유사한 설정으로 테스트

### 프로덕션 환경 (prod)
- **네트워크**: 10.2.0.0/16, 3개 AZ
- **인스턴스**: t3.medium, 최소 3개, 최대 10개
- **목적**: 고가용성, 보안 강화 설정

## 📝 변수 설정

각 서비스별로 `terraform.tfvars` 파일에서 변수를 관리합니다:

### 네트워킹 서비스
```hcl
project_name = "my-project"
aws_region   = "ap-northeast-2"
environment  = "dev"

# 네트워크 설정
vpc_cidr = "10.0.0.0/16"
availability_zones = ["ap-northeast-2a", "ap-northeast-2c"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
```

### 컴퓨팅 서비스
```hcl
project_name = "my-project"
aws_region   = "ap-northeast-2"
environment  = "dev"

# EC2 설정
instance_type    = "t3.micro"
min_size         = 1
max_size         = 2
desired_capacity = 1
```

## 🔒 보안 고려사항

- Terraform 상태 파일은 S3에 암호화되어 저장
- DynamoDB를 사용한 상태 잠금
- 환경별 IAM 역할 분리
- 민감한 정보는 변수로 관리

## 🛠️ 개발 가이드

### 새 모듈 추가

1. `modules/` 디렉터리에 새 모듈 디렉터리 생성
2. `main.tf`, `variables.tf`, `outputs.tf` 파일 작성
3. 환경별 설정에서 모듈 호출

### 새 환경 추가

1. `environments/` 디렉터리에 새 환경 디렉터리 생성
2. 각 서비스별 디렉터리 생성 (`networking/`, `compute/`, `database/`, `storage/`)
3. 각 서비스별로 `main.tf`, `variables.tf`, `outputs.tf`, `terraform.tfvars` 파일 작성
4. 서비스 간 의존성은 `terraform_remote_state` 데이터 소스로 관리

## 📚 참고 자료

- [Terraform 공식 문서](https://www.terraform.io/docs/)
- [AWS Provider 문서](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform 모범 사례](https://www.terraform.io/docs/cloud/guides/recommended-practices/)

<!-- ETC -->

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.
