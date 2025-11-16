# CI/CD 모범 사례 가이드

## PR에서 Terraform Plan 실행 여부

### 현재 설정

- **develop 브랜치 push**: plan 스킵
- **PR (develop → master)**: plan 스킵 (AWS 자격 증명 없음)
- **master 브랜치 push**: plan 실행

### 현업 모범 사례

#### 옵션 1: PR에서 Plan 실행 (권장) ✅

**장점**:
- PR에서 변경사항을 미리 확인 가능
- 리뷰어가 실제 변경 내용을 확인 가능
- 문제를 조기에 발견

**요구사항**:
- GitHub Secrets에 AWS 자격 증명 설정 필요
- PR에서 Secrets 사용 권한 설정 필요

**설정 방법**:
1. GitHub Secrets 설정
   - Settings → Secrets and variables → Actions
   - `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` 추가

2. 워크플로우에서 Secrets 사용
   - PR에서도 Secrets 접근 가능하도록 설정

#### 옵션 2: PR에서는 Validate만, Merge 후 Plan (현재 설정)

**장점**:
- AWS 자격 증명 불필요
- 간단한 설정
- 비용 절감

**단점**:
- PR에서 실제 변경사항 확인 불가
- Merge 후에만 문제 발견 가능

#### 옵션 3: 선택적 Plan 실행

**방법**:
- PR에 특정 라벨이나 코멘트가 있을 때만 plan 실행
- 예: `/plan` 코멘트 시 plan 실행

## 권장 설정

### 시나리오 A: PR에서 Plan 실행 (권장)

```yaml
terraform-plan:
  if: |
    github.event_name == 'pull_request' ||
    (github.event_name == 'push' && (github.ref == 'refs/heads/main' || github.ref == 'refs/heads/master'))
```

**필요한 설정**:
1. GitHub Secrets 설정
2. PR에서 Secrets 사용 권한 활성화 (Settings → Actions → General)

### 시나리오 B: PR에서는 Validate만 (현재)

```yaml
terraform-plan:
  if: github.event_name == 'push' && (github.ref == 'refs/heads/main' || github.ref == 'refs/heads/master')
```

**장점**: 간단하고 안전

## 비교표

| 항목 | PR에서 Plan 실행 | PR에서 Validate만 |
|------|-----------------|-------------------|
| 변경사항 확인 | ✅ 가능 | ❌ 불가 |
| AWS 자격 증명 | ✅ 필요 | ❌ 불필요 |
| 설정 복잡도 | ⚠️ 높음 | ✅ 낮음 |
| 비용 | ⚠️ 약간 증가 | ✅ 최소 |
| 보안 | ⚠️ Secrets 관리 필요 | ✅ 안전 |
| 조기 문제 발견 | ✅ 가능 | ❌ Merge 후 |

## 추천

**소규모 팀/개인 프로젝트**: 
- 현재 설정 유지 (PR에서 Validate만)
- Merge 후 수동으로 plan 확인

**팀 프로젝트/프로덕션**:
- PR에서 Plan 실행 권장
- Secrets 설정 및 권한 관리 필요

