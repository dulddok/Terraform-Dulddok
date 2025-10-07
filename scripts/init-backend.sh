#!/bin/bash

# Terraform 백엔드 수동 생성 가이드 스크립트
# 보안상 이유로 S3 버킷과 DynamoDB 테이블은 수동 생성 권장

set -e

AWS_REGION=${1:-"ap-northeast-2"}
PROJECT_NAME=${2:-"my-project"}

echo "🔒 Terraform 백엔드 수동 생성 가이드"
echo "=================================="
echo "AWS 리전: $AWS_REGION"
echo "프로젝트 이름: $PROJECT_NAME"
echo ""

# 고유한 이름 생성
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BUCKET_NAME="terraform-state-${PROJECT_NAME}-${TIMESTAMP}"
DYNAMODB_TABLE="terraform-locks-${PROJECT_NAME}"

echo "📋 생성할 리소스 정보:"
echo "S3 버킷 이름: $BUCKET_NAME"
echo "DynamoDB 테이블 이름: $DYNAMODB_TABLE"
echo ""

echo "🛠️  AWS 콘솔에서 다음 단계를 수행하세요:"
echo ""
echo "1️⃣  S3 버킷 생성:"
echo "   - 버킷 이름: $BUCKET_NAME"
echo "   - 리전: $AWS_REGION"
echo "   - 버전 관리: 활성화"
echo "   - 서버 측 암호화: 활성화 (AES256)"
echo "   - 퍼블릭 액세스 차단: 활성화"
echo ""
echo "2️⃣  DynamoDB 테이블 생성:"
echo "   - 테이블 이름: $DYNAMODB_TABLE"
echo "   - 파티션 키: LockID (String)"
echo "   - 읽기 용량: 5"
echo "   - 쓰기 용량: 5"
echo "   - 리전: $AWS_REGION"
echo ""

echo "🔧 또는 AWS CLI로 자동 생성하려면:"
echo "   ./scripts/init-backend-auto.sh $AWS_REGION $PROJECT_NAME"
echo ""

echo "📝 생성 완료 후 다음 단계:"
echo "1. environments/*/backend.tf 파일에서 bucket 이름을 '$BUCKET_NAME'으로 업데이트"
echo "2. environments/*/backend.tf 파일에서 dynamodb_table 이름을 '$DYNAMODB_TABLE'으로 업데이트"
echo "3. terraform init 실행"
