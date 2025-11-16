# GitHub 브랜치 보호 규칙 가이드

## 개요

GitHub의 브랜치 보호 규칙(Branch Protection Rules)은 중요한 브랜치(master/main)를 실수로 삭제하거나 잘못된 변경사항을 푸시하는 것을 방지하는 기능입니다.

## 왜 필요한가?

### 보호 규칙 없이 발생할 수 있는 문제

1. ❌ 실수로 `git push --force` 실행 시 히스토리 손실
2. ❌ 실수로 브랜치 삭제
3. ❌ 테스트 없이 직접 master에 push
4. ❌ 코드 리뷰 없이 병합

### 보호 규칙 적용 시

1. ✅ Pull Request를 통한 병합만 허용
2. ✅ 코드 리뷰 필수
3. ✅ CI/CD 검증 통과 필수
4. ✅ Force push 및 삭제 방지

## 설정 방법

### 1단계: GitHub 저장소 설정 페이지로 이동

```
저장소 → Settings → Branches
```

또는 직접 URL:
```
https://github.com/[사용자명]/[저장소명]/settings/branches
```

### 2단계: 브랜치 보호 규칙 추가

1. "Add rule" 또는 "Add branch protection rule" 버튼 클릭
2. Branch name pattern에 `master` 입력 (또는 `main`)

### 3단계: 보호 규칙 설정

#### 필수 설정 (권장)

```
☑️ Require a pull request before merging
  - Require approvals: 1
  - Dismiss stale pull request approvals when new commits are pushed
  - Require review from Code Owners (선택사항)

☑️ Require status checks to pass before merging
  - terraform fmt
  - terraform validate
  - (필요한 CI/CD 체크 추가)

☑️ Require branches to be up to date before merging

☑️ Do not allow bypassing the above settings
```

#### 추가 보안 설정

```
☑️ Restrict who can push to matching branches
  - (특정 사용자/팀만 허용)

☐ Allow force pushes
  - (비활성화 권장)

☐ Allow deletions
  - (비활성화 권장)
```

### 4단계: 저장

"Create" 또는 "Save changes" 클릭

## Terraform 프로젝트 권장 설정

### Status Checks 설정

다음과 같은 검증을 추가하는 것을 권장합니다:

1. **terraform fmt**
   ```yaml
   # .github/workflows/terraform.yml
   - name: Terraform Format Check
     run: terraform fmt -check -recursive
   ```

2. **terraform validate**
   ```yaml
   - name: Terraform Validate
     run: terraform validate
   ```

3. **terraform plan** (선택사항)
   ```yaml
   - name: Terraform Plan
     run: terraform plan
   ```

## 설정 후 워크플로우

### Before (보호 규칙 없음)

```bash
# 직접 master에 push 가능 (위험!)
git checkout master
git merge develop
git push origin master  # ⚠️ 리뷰 없이 바로 반영
```

### After (보호 규칙 적용)

```bash
# 1. develop 브랜치에서 작업
git checkout develop
git add .
git commit -m "feat: 새로운 기능"
git push origin develop

# 2. GitHub에서 Pull Request 생성
# develop → master

# 3. 코드 리뷰 요청
# 4. 리뷰어 승인
# 5. CI/CD 검증 통과
# 6. PR 병합 (GitHub에서만 가능)
```

## 예외 상황 처리

### 긴급 수정이 필요한 경우

브랜치 보호 규칙이 설정되어 있어도 저장소 관리자(Admin)는 다음 방법으로 우회할 수 있습니다:

1. **임시로 보호 규칙 비활성화** (권장하지 않음)
2. **새로운 브랜치 생성 후 PR** (권장)
   ```bash
   git checkout -b hotfix/urgent-fix
   # 수정 작업
   git push origin hotfix/urgent-fix
   # PR 생성 및 빠른 리뷰
   ```

## 확인 방법

### 보호 규칙이 적용되었는지 확인

1. GitHub 저장소 → Settings → Branches
2. Protected branches 섹션에 `master`가 표시되는지 확인

### 테스트

```bash
# force push 시도 (실패해야 함)
git push --force origin master
# Error: You cannot force-push to a protected branch
```

## 주의사항

1. ⚠️ **보호 규칙은 즉시 적용됩니다**
2. ⚠️ **기존에 master에 직접 push하던 워크플로우는 PR 방식으로 변경 필요**
3. ⚠️ **CI/CD 파이프라인이 설정되어 있어야 status checks가 작동합니다**

## 참고 자료

- [GitHub Branch Protection Rules 문서](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [GitHub Actions로 Terraform 검증](https://docs.github.com/en/actions/guides/building-and-testing-python)

