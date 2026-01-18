# GitHub에 프로젝트 업로드하기

이 가이드는 Yahoo Finance 크롤링 프로젝트를 GitHub에 업로드하는 방법을 설명합니다.

## 1단계: Git 설치 확인

먼저 Git이 설치되어 있는지 확인합니다:

```bash
git --version
```

Git이 설치되어 있지 않다면 [Git 공식 사이트](https://git-scm.com/downloads)에서 다운로드하세요.

## 2단계: GitHub 계정 및 저장소 생성

1. [GitHub](https://github.com)에 로그인하거나 계정을 만듭니다.
2. 우측 상단의 **+** 버튼을 클릭하고 **New repository**를 선택합니다.
3. 저장소 이름을 입력합니다 (예: `yahoo-finance-etf-crawler`)
4. **Public** 또는 **Private**을 선택합니다.
5. **Initialize this repository with a README**는 체크하지 않습니다 (이미 README.md가 있으므로).
6. **Create repository**를 클릭합니다.

## 3단계: 로컬에서 Git 초기화

### Windows PowerShell 또는 CMD에서:

```bash
# Yahoo Finance 폴더로 이동
cd "C:\Users\ohdal\OneDrive\문서\03. Cursor\Yahoo Finance"

# Git 저장소 초기화
git init

# 사용자 정보 설정 (처음 한 번만)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# 모든 파일 추가
git add .

# 첫 번째 커밋
git commit -m "Initial commit: Yahoo Finance ETF crawler"

# 원격 저장소 추가 (GitHub에서 생성한 저장소 URL 사용)
git remote add origin https://github.com/your-username/yahoo-finance-etf-crawler.git

# 메인 브랜치 이름 설정
git branch -M main

# GitHub에 푸시
git push -u origin main
```

## 4단계: 인증 (Personal Access Token 필요)

GitHub에 푸시할 때 인증이 필요합니다:

1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. **Generate new token (classic)** 클릭
3. Note: "Yahoo Finance Crawler" 입력
4. Expiration: 원하는 기간 선택
5. Scopes: **repo** 체크
6. **Generate token** 클릭
7. 생성된 토큰을 복사 (다시 볼 수 없으므로 안전하게 보관)

푸시할 때 비밀번호 대신 이 토큰을 사용합니다.

## 5단계: 업데이트된 파일 푸시하기

이후 파일을 수정하고 업로드하려면:

```bash
# 변경된 파일 확인
git status

# 변경된 파일 추가
git add .

# 또는 특정 파일만 추가
git add crawl_etf_gainers.py

# 커밋 (변경 사항 설명)
git commit -m "설명: 변경 내용을 간단히 설명"

# GitHub에 푸시
git push
```

## 6단계: .gitignore 확인

`.gitignore` 파일이 제대로 작동하는지 확인:

- `*.xlsx` 파일은 업로드되지 않습니다 (생성된 엑셀 파일)
- `venv/` 폴더는 업로드되지 않습니다
- `__pycache__/` 폴더는 업로드되지 않습니다

## 주의사항

1. **엑셀 파일은 업로드하지 않음**: `.gitignore`에 `*.xlsx`가 포함되어 있어 생성된 엑셀 파일은 GitHub에 업로드되지 않습니다.

2. **개인 정보 보호**: 
   - API 키나 비밀번호가 있다면 `.env` 파일에 저장하고 `.gitignore`에 추가하세요.
   - 이미 커밋된 파일에 개인 정보가 있다면 Git 히스토리에서 제거해야 합니다.

3. **라이선스 추가** (선택사항):
   - 프로젝트에 `LICENSE` 파일을 추가할 수 있습니다.
   - MIT, Apache 2.0 등 원하는 라이선스를 선택하세요.

## 문제 해결

### 인증 오류
```
remote: Support for password authentication was removed
```
→ Personal Access Token을 사용해야 합니다.

### 파일이 업로드되지 않음
```bash
# .gitignore 확인
cat .gitignore

# 강제로 추가 (권장하지 않음)
git add -f filename.xlsx
```

### 원격 저장소 URL 변경
```bash
# 현재 원격 저장소 확인
git remote -v

# 원격 저장소 URL 변경
git remote set-url origin https://github.com/new-username/new-repo.git
```

## 추가 리소스

- [Git 공식 문서](https://git-scm.com/doc)
- [GitHub 가이드](https://guides.github.com/)
- [Git 명령어 치트시트](https://education.github.com/git-cheat-sheet-education.pdf)
