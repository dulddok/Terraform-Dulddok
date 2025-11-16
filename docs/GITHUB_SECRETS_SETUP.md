# GitHub Secrets 설정 가이드

## 개요

GitHub Secrets는 저장소의 민감한 정보(API 키, 자격 증명 등)를 안전하게 저장하고 GitHub Actions에서 사용할 수 있게 해주는 기능입니다.

## AWS 자격 증명 설정 방법

### 1단계: GitHub 저장소로 이동

1. GitHub 저장소 페이지로 이동
2. **Settings** 탭 클릭
3. 왼쪽 메뉴에서 **Secrets and variables** → **Actions** 클릭

또는 직접 URL:
```
https://github.com/[사용자명]/[저장소명]/settings/secrets/actions
```

### 2단계: 새 Secret 추가

1. **"New repository secret"** 버튼 클릭
2. 다음 Secrets를 각각 추가:

#### Secret 1: AWS_ACCESS_KEY_ID
- **Name**: `AWS_ACCESS_KEY_ID`
- **Secret**: AWS Access Key ID 값 입력
- **Add secret** 클릭

#### Secret 2: AWS_SECRET_ACCESS_KEY
- **Name**: `AWS_SECRET_ACCESS_KEY`
- **Secret**: AWS Secret Access Key 값 입력
- **Add secret** 클릭

### 3단계: AWS 자격 증명 확인

#### AWS IAM에서 Access Key 생성 (없는 경우)

1. AWS 콘솔 로그인
2. IAM 서비스로 이동
3. 사용자 선택 (또는 새 사용자 생성)
4. **Security credentials** 탭
5. **Create access key** 클릭
6. **Command Line Interface (CLI)** 선택
7. Access Key ID와 Secret Access Key 복사

**⚠️ 주의**: Secret Access Key는 한 번만 표시되므로 안전하게 보관하세요!

#### 필요한 IAM 권한

Terraform 작업을 위한 최소 권한:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "vpc:*",
        "route53:*",
        "s3:*",
        "dynamodb:*",
        "iam:*",
        "rds:*",
        "elasticloadbalancing:*"
      ],
      "Resource": "*"
    }
  ]
}
```

또는 더 제한적인 권한으로 필요한 리소스만 허용하는 것을 권장합니다.

## PR에서 Secrets 사용 설정

### 중요: PR에서 Secrets 사용 권한

기본적으로 PR에서는 Secrets에 접근할 수 없습니다. PR에서도 Secrets를 사용하려면:

1. **Settings** → **Actions** → **General**
2. **Workflow permissions** 섹션으로 스크롤
3. **"Read and write permissions"** 선택 (또는 필요한 권한만)
4. **"Allow GitHub Actions to create and approve pull requests"** 체크 (선택사항)
5. 아래로 스크롤하여 **"Allow actions and reusable workflows to be approved by users with read access"** 설정 확인

### PR에서 Secrets 사용 시 보안 고려사항

⚠️ **주의**: PR에서 Secrets를 사용하면:
- Fork된 저장소의 PR에서도 Secrets에 접근 가능할 수 있음
- 신뢰할 수 있는 PR만 허용하도록 설정 필요

**권장 설정**:
- Settings → Actions → General
- **"Require approval for all outside collaborators"** 활성화

## Secrets 확인 방법

### 저장소에서 확인

1. Settings → Secrets and variables → Actions
2. 저장된 Secrets 목록 확인
3. Secrets는 값이 표시되지 않음 (보안상 이유)
4. 편집/삭제만 가능

### GitHub Actions에서 사용 확인

워크플로우 실행 후:
1. Actions 탭 → 실행된 워크플로우 클릭
2. 로그에서 Secrets 사용 확인
3. Secrets 값은 마스킹되어 표시됨 (예: `***`)

## 환경별 Secrets (선택사항)

여러 환경(dev, staging, prod)에 다른 자격 증명을 사용하려면:

### 방법 1: 환경별 Secret 이름

```
AWS_ACCESS_KEY_ID_DEV
AWS_SECRET_ACCESS_KEY_DEV
AWS_ACCESS_KEY_ID_PROD
AWS_SECRET_ACCESS_KEY_PROD
```

### 방법 2: GitHub Environments 사용

1. Settings → Environments
2. 환경 생성 (dev, staging, prod)
3. 각 환경에 Secrets 추가
4. 워크플로우에서 환경 지정:

```yaml
jobs:
  terraform-plan:
    environment: ${{ matrix.environment }}
    steps:
      - uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
```

## 테스트

### Secrets 설정 확인

워크플로우 파일에서 Secrets 사용 확인:

```yaml
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
    aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    aws-region: ${{ env.AWS_REGION }}
```

### 실행 테스트

1. PR 생성 또는 코드 push
2. Actions 탭에서 실행 확인
3. AWS 자격 증명 오류가 없으면 성공

## 문제 해결

### "Credentials could not be loaded" 오류

**원인**:
- Secrets가 설정되지 않음
- Secret 이름이 일치하지 않음
- PR에서 Secrets 접근 권한 없음

**해결**:
1. Secrets 설정 확인
2. Secret 이름 확인 (대소문자 구분)
3. PR에서 Secrets 사용 권한 확인

### PR에서 Secrets 접근 불가

**원인**:
- 기본적으로 PR에서는 Secrets 접근 제한
- Fork된 저장소의 PR

**해결**:
1. Settings → Actions → General
2. Workflow permissions 설정 확인
3. "Require approval" 설정 확인

## 보안 모범 사례

1. ✅ **최소 권한 원칙**: 필요한 권한만 부여
2. ✅ **정기적 로테이션**: Access Key 정기적으로 교체
3. ✅ **환경 분리**: dev/staging/prod 자격 증명 분리
4. ✅ **감사 로깅**: CloudTrail로 사용 내역 모니터링
5. ✅ **PR 승인**: 신뢰할 수 있는 PR만 Secrets 사용

## 참고 자료

- [GitHub Secrets 문서](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [AWS IAM 사용자 생성](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html)
- [GitHub Actions 보안 모범 사례](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)

