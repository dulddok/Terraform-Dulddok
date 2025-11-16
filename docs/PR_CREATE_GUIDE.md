# Pull Request 생성 가이드

## 빠른 링크

**PR 생성 페이지**: https://github.com/dulddok/Terraform-Dulddok/compare/master...develop

## 단계별 가이드

### 1. PR 생성 페이지로 이동

위 링크를 클릭하거나:

1. GitHub 저장소 페이지로 이동
2. "Pull requests" 탭 클릭
3. "New pull request" 버튼 클릭
4. Base: `master` 선택
5. Compare: `develop` 선택

### 2. PR 정보 입력

**제목** (예시):
```
chore: Add GitHub Actions workflow for master branch and documentation
```

**설명** (예시):
```markdown
## 변경사항
- GitHub Actions 워크플로우에 master 브랜치 추가
- 브랜치 보호 규칙 설정 가이드 문서 추가
- Status checks 설정 가이드 추가

## 목적
- master 브랜치에 대한 PR에서도 GitHub Actions가 실행되도록 설정
- 브랜치 보호 규칙 설정을 위한 문서화

## 체크리스트
- [x] 코드 검토 완료
- [x] 문서 업데이트 완료
- [ ] 테스트 완료 (필요한 경우)
```

### 3. PR 생성

1. "Create pull request" 버튼 클릭
2. GitHub Actions가 자동으로 실행됨
3. "Checks" 탭에서 실행 상태 확인

### 4. Status Checks 확인

PR 페이지에서:
- "Checks" 탭 클릭
- 다음 워크플로우가 실행되는지 확인:
  - `Terraform Validate / dev`
  - `Terraform Validate / staging`
  - `Terraform Validate / prod`

### 5. Status Checks가 나타나면

브랜치 보호 규칙 설정:
1. Settings → Branches
2. master 브랜치 보호 규칙 편집
3. "Require status checks to pass before merging" 체크
4. 나타난 status checks 선택:
   - `Terraform Validate / dev`
   - `Terraform Validate / staging`
   - `Terraform Validate / prod`
5. 저장

## 참고

- Status checks는 PR이 생성되고 GitHub Actions가 실행된 후에만 나타납니다
- 첫 번째 PR에서는 status checks가 없을 수 있으므로, 먼저 PR을 생성하고 Actions가 실행된 후 브랜치 보호 규칙을 업데이트하세요

