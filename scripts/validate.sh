#!/bin/bash

# Terraform 검증 스크립트
# 사용법: ./validate.sh [environment] [service]

set -e

ENVIRONMENT=${1:-"all"}
SERVICE=${2:-"all"}

echo "🔍 Terraform 구조 검증 시작..."

# 모든 환경과 서비스 검증
if [ "$ENVIRONMENT" = "all" ] && [ "$SERVICE" = "all" ]; then
    echo "전체 환경 및 서비스 검증 중..."
    
    for env in dev staging prod; do
        for service in networking compute; do
            SERVICE_DIR="environments/$env/$service"
            if [ -d "$SERVICE_DIR" ]; then
                echo "📁 검증 중: $SERVICE_DIR"
                
                cd "$SERVICE_DIR"
                
                # Terraform 초기화
                echo "  🔧 초기화 중..."
                terraform init -backend=false > /dev/null 2>&1
                
                # Terraform 검증
                echo "  ✅ 검증 중..."
                if terraform validate > /dev/null 2>&1; then
                    echo "  ✅ $SERVICE_DIR: 검증 성공"
                else
                    echo "  ❌ $SERVICE_DIR: 검증 실패"
                    terraform validate
                    exit 1
                fi
                
                # Terraform 포맷 검사
                echo "  🎨 포맷 검사 중..."
                if terraform fmt -check > /dev/null 2>&1; then
                    echo "  ✅ $SERVICE_DIR: 포맷 OK"
                else
                    echo "  ⚠️  $SERVICE_DIR: 포맷 수정 필요"
                    terraform fmt
                fi
                
                cd - > /dev/null
                echo ""
            fi
        done
    done

# 특정 환경의 모든 서비스 검증
elif [ "$SERVICE" = "all" ]; then
    echo "$ENVIRONMENT 환경의 모든 서비스 검증 중..."
    
    for service in networking compute; do
        SERVICE_DIR="environments/$ENVIRONMENT/$service"
        if [ -d "$SERVICE_DIR" ]; then
            echo "📁 검증 중: $SERVICE_DIR"
            
            cd "$SERVICE_DIR"
            
            # Terraform 초기화
            echo "  🔧 초기화 중..."
            terraform init -backend=false > /dev/null 2>&1
            
            # Terraform 검증
            echo "  ✅ 검증 중..."
            if terraform validate > /dev/null 2>&1; then
                echo "  ✅ $SERVICE_DIR: 검증 성공"
            else
                echo "  ❌ $SERVICE_DIR: 검증 실패"
                terraform validate
                exit 1
            fi
            
            cd - > /dev/null
            echo ""
        fi
    done

# 특정 서비스 검증
else
    SERVICE_DIR="environments/$ENVIRONMENT/$SERVICE"
    if [ -d "$SERVICE_DIR" ]; then
        echo "📁 검증 중: $SERVICE_DIR"
        
        cd "$SERVICE_DIR"
        
        # Terraform 초기화
        echo "  🔧 초기화 중..."
        terraform init -backend=false > /dev/null 2>&1
        
        # Terraform 검증
        echo "  ✅ 검증 중..."
        if terraform validate > /dev/null 2>&1; then
            echo "  ✅ $SERVICE_DIR: 검증 성공"
        else
            echo "  ❌ $SERVICE_DIR: 검증 실패"
            terraform validate
            exit 1
        fi
        
        cd - > /dev/null
    else
        echo "❌ 오류: $SERVICE_DIR 디렉터리가 존재하지 않습니다."
        exit 1
    fi
fi

echo "🎉 모든 검증이 완료되었습니다!"

