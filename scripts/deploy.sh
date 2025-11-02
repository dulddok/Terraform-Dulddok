#!/bin/bash

# Terraform 배포 스크립트 (서비스별 구조)
# 사용법: ./deploy.sh <environment> <service> <action>
# 예시: ./deploy.sh dev networking plan
# 예시: ./deploy.sh prod compute apply

set -e

ENVIRONMENT=$1
SERVICE=$2
ACTION=$3

if [ -z "$ENVIRONMENT" ] || [ -z "$SERVICE" ] || [ -z "$ACTION" ]; then
    echo "사용법: $0 <environment> <service> <action>"
    echo "환경: dev, staging, prod"
    echo "서비스: networking, compute, database, storage"
    echo "액션: plan, apply, destroy"
    echo ""
    echo "예시:"
    echo "  $0 dev networking plan"
    echo "  $0 prod compute apply"
    exit 1
fi

# 환경별 서비스 디렉터리 확인
SERVICE_DIR="environments/$ENVIRONMENT/$SERVICE"
if [ ! -d "$SERVICE_DIR" ]; then
    echo "오류: $SERVICE_DIR 디렉터리가 존재하지 않습니다."
    echo "사용 가능한 서비스:"
    ls -1 "environments/$ENVIRONMENT/" 2>/dev/null || echo "  (없음)"
    exit 1
fi

echo "환경: $ENVIRONMENT"
echo "서비스: $SERVICE"
echo "액션: $ACTION"
echo "디렉터리: $SERVICE_DIR"

# 디렉터리 이동
cd "$SERVICE_DIR"

# Terraform 초기화
echo "Terraform 초기화 중..."
terraform init

# Terraform 검증
echo "Terraform 검증 중..."
terraform validate

# 액션 실행
case $ACTION in
    plan)
        echo "Terraform 계획 생성 중..."
        terraform plan -var-file="terraform.tfvars"
        ;;
    apply)
        echo "Terraform 계획 생성 중..."
        terraform plan -var-file="terraform.tfvars"
        echo ""
        echo "경고: $SERVICE 서비스의 인프라를 배포하려고 합니다!"
        read -p "위 계획을 적용하시겠습니까? (yes/no): " confirm
        if [ "$confirm" = "yes" ]; then
            terraform apply -var-file="terraform.tfvars" -auto-approve
        else
            echo "배포가 취소되었습니다."
        fi
        ;;
    destroy)
        echo "현재 상태 확인 중..."
        terraform show -no-color
        echo ""
        echo "삭제 계획 생성 중..."
        terraform plan -destroy -var-file="terraform.tfvars"
        echo ""
        echo "경고: $SERVICE 서비스의 인프라를 삭제하려고 합니다!"
        read -p "위 계획을 적용하여 삭제하시겠습니까? (yes/no): " confirm
        if [ "$confirm" = "yes" ]; then
            terraform destroy -var-file="terraform.tfvars" -auto-approve
        else
            echo "삭제가 취소되었습니다."
        fi
        ;;
    *)
        echo "지원하지 않는 액션: $ACTION"
        echo "지원하는 액션: plan, apply, destroy"
        exit 1
        ;;
esac

echo "완료!"
