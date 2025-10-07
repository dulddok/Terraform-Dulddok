# 아키텍처 문서

## 개요

이 문서는 Terraform을 사용한 AWS 인프라 구성의 아키텍처를 설명합니다.

## 네트워크 아키텍처

### VPC 구성
- **CIDR**: 10.0.0.0/16
- **가용 영역**: 2개 (ap-northeast-2a, ap-northeast-2c)
- **서브넷**: Public/Private 서브넷 각 2개

### 서브넷 구성
```
Public Subnets:
- 10.0.1.0/24 (ap-northeast-2a)
- 10.0.2.0/24 (ap-northeast-2c)

Private Subnets:
- 10.0.10.0/24 (ap-northeast-2a)
- 10.0.20.0/24 (ap-northeast-2c)
```

### 네트워크 컴포넌트
- **Internet Gateway**: 퍼블릭 서브넷의 인터넷 접근
- **NAT Gateway**: 프라이빗 서브넷의 아웃바운드 인터넷 접근
- **Route Tables**: 서브넷별 라우팅 규칙

## 컴퓨팅 아키텍처

### EC2 구성
- **Auto Scaling Group**: 자동 스케일링
- **Launch Template**: 인스턴스 템플릿
- **Security Groups**: 네트워크 보안

### 인스턴스 설정
- **AMI**: Amazon Linux 2
- **인스턴스 타입**: t3.micro (dev), t3.small (staging), t3.medium (prod)
- **스케일링**: 최소 1, 최대 3, 원하는 용량 2

## 보안 아키텍처

### Security Groups
- **SSH**: 22번 포트 (제한된 CIDR)
- **HTTP**: 80번 포트 (전체 허용)
- **HTTPS**: 443번 포트 (전체 허용)

### IAM 정책
- 최소 권한 원칙
- 환경별 역할 분리
- 리소스별 접근 제어

## 모니터링 및 로깅

### CloudWatch
- 인스턴스 메트릭 수집
- 로그 그룹 관리
- 알람 설정

### 로그 관리
- 애플리케이션 로그
- 시스템 로그
- 보안 로그

## 재해 복구

### 백업 전략
- EBS 스냅샷
- RDS 백업
- S3 버전 관리

### 다중 AZ 배포
- 가용 영역 분산
- 자동 장애 조치
- 로드 밸런싱

## 비용 최적화

### 인스턴스 최적화
- 적절한 인스턴스 타입 선택
- 스팟 인스턴스 활용
- 예약 인스턴스 고려

### 스토리지 최적화
- S3 스토리지 클래스 활용
- EBS 최적화
- 불필요한 리소스 정리

## 확장성 고려사항

### 수평 확장
- Auto Scaling Group
- 로드 밸런서
- 데이터베이스 샤딩

### 수직 확장
- 인스턴스 타입 변경
- 스토리지 확장
- 네트워크 대역폭 증가
