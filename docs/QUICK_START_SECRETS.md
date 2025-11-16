# GitHub Secrets 빠른 설정 가이드

## 5분 안에 설정하기

### 1. GitHub 저장소 설정 페이지로 이동

```
https://github.com/[사용자명]/[저장소명]/settings/secrets/actions
```

또는:
1. 저장소 → **Settings**
2. **Secrets and variables** → **Actions**

### 2. AWS 자격 증명 추가

**Secret 1**:
- Name: `AWS_ACCESS_KEY_ID`
- Value: AWS Access Key ID

**Secret 2**:
- Name: `AWS_SECRET_ACCESS_KEY`
- Value: AWS Secret Access Key

각각 **"Add secret"** 클릭

### 3. AWS Access Key가 없다면?

1. AWS 콘솔 → IAM → 사용자
2. 사용자 선택 → **Security credentials**
3. **Create access key** → **CLI** 선택
4. Access Key ID와 Secret Access Key 복사

### 4. PR에서 Secrets 사용 허용 (선택사항)

PR에서 terraform plan을 실행하려면:

1. Settings → **Actions** → **General**
2. **Workflow permissions** → **Read and write permissions**
3. 저장

### 5. 확인

다음 PR이나 push에서 GitHub Actions가 AWS 자격 증명을 사용할 수 있습니다.

## 현재 프로젝트에서 사용하는 Secrets

워크플로우 파일에서 다음 Secrets를 사용합니다:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

이 Secrets가 설정되어 있으면:
- ✅ terraform-plan 작업 실행 가능
- ✅ terraform-apply 작업 실행 가능
- ✅ PR에서도 plan 실행 가능 (권한 설정 시)

## 주의사항

⚠️ **Secret Access Key는 한 번만 표시됩니다!**
- 복사 후 안전하게 보관
- 분실 시 재생성 필요

⚠️ **PR에서 Secrets 사용 시**
- Fork된 저장소의 PR에서는 보안상 제한될 수 있음
- 신뢰할 수 있는 PR만 허용 권장

