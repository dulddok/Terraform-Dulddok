terraform {
  backend "s3" {
    # 백엔드 설정은 backend.hcl 파일에서 읽어옵니다
    # init-backend.sh 또는 init-backend-auto.sh 스크립트로 설정하세요
  }
}

