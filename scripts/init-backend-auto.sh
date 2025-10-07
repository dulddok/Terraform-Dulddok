#!/bin/bash

# Terraform 백엔드 자동 생성 스크립트 (개발/테스트용)
# ⚠️  주의: 프로덕션 환경에서는 수동 생성 권장

set -e

AWS_REGION=${1:-"ap-northeast-2"}
PROJECT_NAME=${2:-"my-project"}

echo "⚠️  자동 생성 모드 (개발/테스트용)"
echo "AWS 리전: $AWS_REGION"
echo "프로젝트 이름: $PROJECT_NAME"

# S3 버킷 이름 생성 (고유해야 함)
BUCKET_NAME="terraform-state-${PROJECT_NAME}-$(date +%s)"
DYNAMODB_TABLE="terraform-locks-${PROJECT_NAME}"

echo "S3 버킷 이름: $BUCKET_NAME"
echo "DynamoDB 테이블 이름: $DYNAMODB_TABLE"

# S3 버킷 생성
echo "S3 버킷 생성 중..."
aws s3 mb s3://$BUCKET_NAME --region $AWS_REGION

# S3 버킷 버전 관리 활성화
aws s3api put-bucket-versioning \
    --bucket $BUCKET_NAME \
    --versioning-configuration Status=Enabled

# S3 버킷 암호화 설정
aws s3api put-bucket-encryption \
    --bucket $BUCKET_NAME \
    --server-side-encryption-configuration '{
        "Rules": [
            {
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                }
            }
        ]
    }'

# S3 버킷 퍼블릭 액세스 차단
aws s3api put-public-access-block \
    --bucket $BUCKET_NAME \
    --public-access-block-configuration \
    BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

# DynamoDB 테이블 생성
echo "DynamoDB 테이블 생성 중..."
aws dynamodb create-table \
    --table-name $DYNAMODB_TABLE \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --region $AWS_REGION

# 테이블 생성 대기
echo "DynamoDB 테이블 생성 대기 중..."
aws dynamodb wait table-exists --table-name $DYNAMODB_TABLE --region $AWS_REGION

echo "✅ 백엔드 자동 생성 완료!"
echo ""
echo "📝 다음 단계:"
echo "1. environments/*/backend.tf 파일에서 bucket 이름을 '$BUCKET_NAME'으로 업데이트"
echo "2. environments/*/backend.tf 파일에서 dynamodb_table 이름을 '$DYNAMODB_TABLE'으로 업데이트"
echo "3. terraform init 실행"
