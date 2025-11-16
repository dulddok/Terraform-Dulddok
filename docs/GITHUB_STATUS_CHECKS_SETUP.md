# GitHub Status Checks 설정 가이드

## 문제: "Required status checks cannot be empty"

브랜치 보호 규칙에서 "Require status checks to pass before merging"을 활성화했지만, 실제로 실행될 status check가 없어서 발생하는 오류입니다.

## 해결 방법

### 방법 1: Status Checks 옵션 비활성화 (빠른 해결)

브랜치 보호 규칙 설정에서:

1. **"Require status checks to pass before merging"** 체크박스 **해제**
2. 나머지 설정은 그대로 유지:
   - ☑️ Require a pull request before merging
   - ☑️ Allow force pushes: ❌ (비활성화)
   - ☑️ Allow deletions: ❌ (비활성화)
3. 저장

**장점**: 즉시 설정 완료  
**단점**: CI/CD 검증 없이 병합 가능

### 방법 2: Status Checks 설정 (권장)

#### 2-1. GitHub Actions 워크플로우 확인

프로젝트에 `.github/workflows/terraform.yml` 파일이 있습니다. 이 워크플로우가 실행되면 status checks가 생성됩니다.

#### 2-2. 워크플로우가 master 브랜치를 포함하는지 확인

`.github/workflows/terraform.yml` 파일에서:

```yaml
on:
  pull_request:
    branches: [ main, master ]  # master 포함 확인
```

#### 2-3. 첫 번째 PR 생성 및 실행

1. develop 브랜치에서 변경사항 커밋
2. develop → master로 Pull Request 생성
3. GitHub Actions가 자동으로 실행됨
4. Actions 탭에서 실행 상태 확인

#### 2-4. Status Checks 확인

PR 페이지에서:
- "Checks" 탭 클릭
- 실행된 워크플로우 확인:
  - `Terraform Validate / dev`
  - `Terraform Validate / staging`
  - `Terraform Validate / prod`
  - `Terraform Format Check`

#### 2-5. 브랜치 보호 규칙에 Status Checks 추가

1. GitHub 저장소 → Settings → Branches
2. master 브랜치 보호 규칙 편집
3. "Require status checks to pass before merging" 체크
4. "Require branches to be up to date before merging" 체크
5. 아래에서 사용할 status checks 선택:
   - ☑️ `Terraform Validate / dev`
   - ☑️ `Terraform Validate / staging`
   - ☑️ `Terraform Validate / prod`
   - ☑️ `Terraform Format Check` (있는 경우)
6. 저장

**참고**: Status checks는 최소 한 번 실행되어야 목록에 나타납니다.

## 빠른 설정 가이드

### 지금 바로 설정하려면 (방법 1)

```
1. Settings → Branches
2. master 브랜치 보호 규칙 편집
3. "Require status checks to pass before merging" ❌ (비활성화)
4. 나머지 설정 유지
5. 저장
```

### 나중에 Status Checks 추가하려면 (방법 2)

```
1. 먼저 방법 1로 설정 완료
2. develop → master로 PR 생성
3. GitHub Actions 실행 대기
4. Status checks 목록 확인
5. 브랜치 보호 규칙에 status checks 추가
```

## Status Checks가 보이지 않는 경우

### 원인
- 워크플로우가 아직 실행되지 않음
- 워크플로우 파일에 오류가 있음
- PR이 생성되지 않음

### 해결
1. **PR 생성**: develop → master로 Pull Request 생성
2. **Actions 확인**: GitHub Actions 탭에서 실행 상태 확인
3. **워크플로우 수정**: `.github/workflows/terraform.yml` 확인

## 권장 설정 (최종)

브랜치 보호 규칙에서:

```
☑️ Require a pull request before merging
  - Require approvals: 1
  - Dismiss stale pull request approvals when new commits are pushed

☑️ Require status checks to pass before merging
  - ☑️ Terraform Validate / dev
  - ☑️ Terraform Validate / staging  
  - ☑️ Terraform Validate / prod
  - ☑️ Require branches to be up to date before merging

☑️ Do not allow bypassing the above settings

☐ Allow force pushes (비활성화)
☐ Allow deletions (비활성화)
```

## 테스트

설정 후 테스트:

```bash
# develop 브랜치에서 변경
git checkout develop
echo "# test" >> README.md
git add README.md
git commit -m "test: status checks 테스트"
git push origin develop

# GitHub에서 PR 생성
# → Status checks가 실행되는지 확인
# → 모든 체크가 통과해야 병합 가능
```

