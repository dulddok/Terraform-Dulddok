#!/bin/bash

# Terraform .terraform 디렉토리 정리 스크립트
# 백엔드 설정 변경 후 사용

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🧹 Terraform .terraform 디렉토리 정리 중..."
echo "프로젝트 루트: $PROJECT_ROOT"
echo ""

# .terraform 디렉토리 찾기
TERRAFORM_DIRS=$(find "$PROJECT_ROOT/environments" -type d -name ".terraform" 2>/dev/null || true)

if [ -z "$TERRAFORM_DIRS" ]; then
    echo "✅ 정리할 .terraform 디렉토리가 없습니다."
    exit 0
fi

echo "다음 디렉토리들을 삭제합니다:"
echo "$TERRAFORM_DIRS" | while read -r dir; do
    echo "  - $dir"
done
echo ""

read -p "정말 삭제하시겠습니까? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "취소되었습니다."
    exit 0
fi

# .terraform 디렉토리 삭제
echo "$TERRAFORM_DIRS" | while read -r dir; do
    if [ -d "$dir" ]; then
        echo "삭제 중: $dir"
        rm -rf "$dir"
    fi
done

echo ""
echo "✅ 모든 .terraform 디렉토리가 삭제되었습니다."
echo "이제 deploy.sh를 실행하면 새로운 백엔드로 초기화됩니다."
