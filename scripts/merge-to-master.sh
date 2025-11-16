#!/bin/bash

# develop 브랜치의 변경사항을 master로 병합하는 스크립트
# 사용법: ./scripts/merge-to-master.sh

set -e

echo "🔄 develop → master 병합 시작..."

# 현재 브랜치 확인
CURRENT_BRANCH=$(git branch --show-current)
echo "현재 브랜치: $CURRENT_BRANCH"

if [ "$CURRENT_BRANCH" != "develop" ]; then
    echo "⚠️  경고: 현재 develop 브랜치가 아닙니다."
    read -p "develop 브랜치로 전환하시겠습니까? (y/n): " confirm
    if [ "$confirm" = "y" ]; then
        git checkout develop
    else
        echo "취소되었습니다."
        exit 1
    fi
fi

# 변경사항 확인
if [ -n "$(git status --porcelain)" ]; then
    echo "📝 커밋되지 않은 변경사항이 있습니다."
    git status --short
    
    read -p "변경사항을 커밋하시겠습니까? (y/n): " confirm
    if [ "$confirm" = "y" ]; then
        read -p "커밋 메시지를 입력하세요: " commit_msg
        if [ -z "$commit_msg" ]; then
            commit_msg="chore: terraform fmt 포맷팅 및 개선사항 적용"
        fi
        git add .
        git commit -m "$commit_msg"
        echo "✅ 변경사항 커밋 완료"
    else
        echo "⚠️  변경사항을 먼저 커밋하거나 stash하세요."
        exit 1
    fi
fi

# develop 브랜치 푸시
echo "📤 develop 브랜치 푸시 중..."
git push origin develop

# master 브랜치로 전환
echo "🔄 master 브랜치로 전환 중..."
git checkout master

# master 브랜치 최신화
echo "⬇️  master 브랜치 최신화 중..."
git pull origin master

# develop 브랜치 병합
echo "🔀 develop 브랜치 병합 중..."
if git merge develop --no-edit; then
    echo "✅ 병합 성공!"
    
    # master 브랜치 푸시
    read -p "master 브랜치에 푸시하시겠습니까? (y/n): " confirm
    if [ "$confirm" = "y" ]; then
        git push origin master
        echo "✅ master 브랜치 푸시 완료"
    fi
    
    # develop 브랜치로 돌아가기
    read -p "develop 브랜치로 돌아가시겠습니까? (y/n): " confirm
    if [ "$confirm" = "y" ]; then
        git checkout develop
        echo "✅ develop 브랜치로 전환 완료"
    fi
else
    echo "❌ 병합 충돌 발생! 수동으로 해결해주세요."
    echo "충돌 해결 후: git add . && git commit"
    exit 1
fi

echo "🎉 완료!"

