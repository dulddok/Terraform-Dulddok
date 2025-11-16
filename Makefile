# Terraform AWS 인프라 관리 Makefile

.PHONY: help init init-any validate format plan apply destroy clean

# 기본 타겟
help: ## 도움말 표시
	@echo "사용 가능한 명령어:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

# 백엔드 초기화
init-backend: ## S3 백엔드 초기화
	@echo "🔧 백엔드 초기화 중..."
	./scripts/init-backend.sh

# 검증
validate: ## 모든 환경 및 서비스 검증
	@echo "🔍 전체 검증 중..."
	./scripts/validate.sh

validate-dev: ## dev 환경 검증
	@echo "🔍 dev 환경 검증 중..."
	./scripts/validate.sh dev

validate-staging: ## staging 환경 검증
	@echo "🔍 staging 환경 검증 중..."
	./scripts/validate.sh staging

validate-prod: ## prod 환경 검증
	@echo "🔍 prod 환경 검증 중..."
	./scripts/validate.sh prod

# 포맷팅
format: ## 모든 Terraform 파일 포맷팅
	@echo "🎨 포맷팅 중..."
	@find environments -name "*.tf" -exec terraform fmt {} \;
	@find modules -name "*.tf" -exec terraform fmt {} \;

# 계획
plan-dev-networking: ## dev 환경 networking 계획
	./scripts/deploy.sh dev networking plan

plan-dev-compute: ## dev 환경 compute 계획
	./scripts/deploy.sh dev compute plan

plan-staging-networking: ## staging 환경 networking 계획
	./scripts/deploy.sh staging networking plan

plan-staging-compute: ## staging 환경 compute 계획
	./scripts/deploy.sh staging compute plan

plan-prod-networking: ## prod 환경 networking 계획
	./scripts/deploy.sh prod networking plan

plan-prod-compute: ## prod 환경 compute 계획
	./scripts/deploy.sh prod compute plan

plan-dev-privatelink: ## dev 환경 privatelink 계획
	./scripts/deploy.sh dev privatelink plan

plan-dev-privatelink-consumer: ## dev 환경 privatelink-consumer 계획
	./scripts/deploy.sh dev privatelink-consumer plan

# 배포
deploy-dev-networking: ## dev 환경 networking 배포
	./scripts/deploy.sh dev networking apply

deploy-dev-compute: ## dev 환경 compute 배포
	./scripts/deploy.sh dev compute apply

deploy-staging-networking: ## staging 환경 networking 배포
	./scripts/deploy.sh staging networking apply

deploy-staging-compute: ## staging 환경 compute 배포
	./scripts/deploy.sh staging compute apply

deploy-prod-networking: ## prod 환경 networking 배포
	./scripts/deploy.sh prod networking apply

deploy-prod-compute: ## prod 환경 compute 배포
	./scripts/deploy.sh prod compute apply

deploy-dev-privatelink: ## dev 환경 privatelink 배포
	./scripts/deploy.sh dev privatelink apply

deploy-dev-privatelink-consumer: ## dev 환경 privatelink-consumer 배포
	./scripts/deploy.sh dev privatelink-consumer apply

# 전체 배포 (순서대로)
deploy-dev: deploy-dev-networking deploy-dev-compute deploy-dev-privatelink deploy-dev-privatelink-consumer ## dev 환경 전체 배포

deploy-staging: deploy-staging-networking deploy-staging-compute ## staging 환경 전체 배포

deploy-prod: deploy-prod-networking deploy-prod-compute ## prod 환경 전체 배포

# 삭제
destroy-dev-networking: ## dev 환경 networking 삭제
	./scripts/deploy.sh dev networking destroy

destroy-dev-compute: ## dev 환경 compute 삭제
	./scripts/deploy.sh dev compute destroy

destroy-staging-networking: ## staging 환경 networking 삭제
	./scripts/deploy.sh staging networking destroy

destroy-staging-compute: ## staging 환경 compute 삭제
	./scripts/deploy.sh staging compute destroy

destroy-prod-networking: ## prod 환경 networking 삭제
	./scripts/deploy.sh prod networking destroy

destroy-prod-compute: ## prod 환경 compute 삭제
	./scripts/deploy.sh prod compute destroy

destroy-dev-privatelink: ## dev 환경 privatelink 삭제
	./scripts/deploy.sh dev privatelink destroy

destroy-dev-privatelink-consumer: ## dev 환경 privatelink-consumer 삭제
	./scripts/deploy.sh dev privatelink-consumer destroy

# 정리
clean: ## .terraform 디렉터리 정리
	@echo "🧹 정리 중..."
	@find environments -name ".terraform" -type d -exec rm -rf {} + 2>/dev/null || true
	@find environments -name ".terraform.lock.hcl" -delete 2>/dev/null || true
	@find environments -name "terraform.tfstate*" -delete 2>/dev/null || true

# 개발 환경 전체 설정
dev-setup: init-backend validate-dev format ## dev 환경 전체 설정

# 스테이징 환경 전체 설정
staging-setup: init-backend validate-staging format ## staging 환경 전체 설정

# 프로덕션 환경 전체 설정
prod-setup: init-backend validate-prod format ## prod 환경 전체 설정

