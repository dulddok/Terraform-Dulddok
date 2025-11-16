# Git 브랜치 워크플로우 가이드

## 브랜치 전략

- **`master`**: 프로덕션 환경 (안정적인 코드)
- **`develop`**: 개발 환경 (실험/테스트용)

## 일반적인 워크플로우

### 1. develop 브랜치에서 작업

```bash
# develop 브랜치로 전환
git checkout develop

# 작업 후 변경사항 커밋
git add .
git commit -m "feat: 새로운 기능 추가"

# 원격 저장소에 푸시
git push origin develop
```

### 2. develop → master 병합

#### 방법 1: Pull Request 사용 (권장)

```bash
# GitHub/GitLab에서 Pull Request 생성
# develop → master로 PR 생성 후 리뷰 및 승인
```

#### 방법 2: 직접 병합

```bash
# 1. develop 브랜치의 변경사항 커밋 확인
git checkout develop
git log --oneline -5

# 2. master 브랜치로 전환
git checkout master

# 3. master 브랜치 최신화
git pull origin master

# 4. develop 브랜치를 master로 병합
git merge develop

# 5. 충돌이 있다면 해결 후
git add .
git commit -m "Merge branch 'develop' into master"

# 6. 원격 저장소에 푸시
git push origin master
```

### 3. master → develop 백머지 (동기화)

master에 변경사항이 있다면 develop에도 반영:

```bash
# 1. develop 브랜치로 전환
git checkout develop

# 2. master의 변경사항을 develop으로 병합
git merge master

# 3. 충돌 해결 후 푸시
git push origin develop
```

## 현재 작업을 master에 적용하는 방법

### 시나리오: develop에서 작업한 내용을 master에도 적용

```bash
# 1. 현재 변경사항 커밋 (develop 브랜치)
git add .
git commit -m "fix: terraform fmt 포맷팅 수정 및 개선사항 적용"

# 2. master 브랜치로 전환
git checkout master

# 3. master 최신화
git pull origin master

# 4. develop 병합
git merge develop

# 5. 푸시
git push origin master

# 6. develop으로 돌아가기 (선택사항)
git checkout develop
```

## 주의사항

1. **항상 최신화**: master로 전환하기 전에 `git pull` 실행
2. **충돌 해결**: 병합 시 충돌이 발생하면 신중하게 해결
3. **테스트**: master에 병합하기 전에 충분히 테스트
4. **커밋 메시지**: Conventional Commits 규칙 준수

## 유용한 명령어

```bash
# 현재 브랜치 확인
git branch

# 브랜치 목록 확인
git branch -a

# 변경사항 확인
git status

# 커밋 히스토리 확인
git log --oneline --graph --all

# 특정 커밋만 master에 적용 (cherry-pick)
git checkout master
git cherry-pick <commit-hash>
```

