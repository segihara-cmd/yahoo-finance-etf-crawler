# GitHub 업로드 상세 가이드 - 4단계

## 4단계: 원격 저장소 연결 및 푸시 (자세한 설명)

### 4-1. GitHub에서 저장소 URL 확인하기

1. GitHub 웹사이트에 로그인합니다: https://github.com
2. 방금 생성한 저장소 페이지로 이동합니다
3. 저장소 페이지에서 **초록색 "Code" 버튼**을 클릭합니다
4. 나타나는 팝업에서 **HTTPS** 탭이 선택되어 있는지 확인합니다
5. 아래와 같은 URL이 보입니다:
   ```
   https://github.com/사용자명/저장소명.git
   ```
   예시: `https://github.com/ohdal/yahoo-finance-etf-crawler.git`

6. 이 URL을 **복사**합니다 (우측의 복사 버튼 클릭)

### 4-2. PowerShell 또는 CMD에서 명령어 실행

#### Windows PowerShell 열기

1. **Windows 키 + X** 누르기
2. **Windows PowerShell** 또는 **터미널** 선택
3. 또는 **시작 메뉴**에서 "PowerShell" 검색

#### 명령어 실행 순서

**1) Yahoo Finance 폴더로 이동**
```powershell
cd "C:\Users\ohdal\OneDrive\문서\03. Cursor\Yahoo Finance"
```

**2) 원격 저장소 추가**
```powershell
git remote add origin https://github.com/사용자명/저장소명.git
```
⚠️ **중요**: `사용자명`과 `저장소명`을 실제 값으로 바꿔야 합니다!

예시:
```powershell
git remote add origin https://github.com/ohdal/yahoo-finance-etf-crawler.git
```

**3) 메인 브랜치 이름 설정**
```powershell
git branch -M main
```

**4) GitHub에 푸시 (업로드)**
```powershell
git push -u origin main
```

### 4-3. 인증 과정

`git push` 명령어를 실행하면 인증을 요청합니다:

#### 방법 1: Personal Access Token 사용 (권장)

1. **Username (사용자명) 입력**: GitHub 사용자명 입력
2. **Password (비밀번호) 입력**: 
   - ⚠️ **일반 비밀번호가 아닙니다!**
   - Personal Access Token을 입력해야 합니다

#### Personal Access Token 생성하기

1. GitHub 웹사이트에서 우측 상단 **프로필 사진** 클릭
2. **Settings** 클릭
3. 왼쪽 메뉴에서 맨 아래 **Developer settings** 클릭
4. **Personal access tokens** → **Tokens (classic)** 클릭
5. **Generate new token** → **Generate new token (classic)** 클릭
6. **Note**에 토큰 설명 입력 (예: "Yahoo Finance Crawler")
7. **Expiration** 선택 (예: 90 days 또는 No expiration)
8. **Select scopes**에서 **repo** 체크박스 선택
   - 이렇게 하면 하위 항목들도 자동으로 선택됩니다
9. 맨 아래 **Generate token** 버튼 클릭
10. 생성된 토큰을 **즉시 복사**합니다 (다시 볼 수 없습니다!)
    - 예: `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

#### 토큰 사용하기

`git push` 명령어 실행 후:
- **Username**: GitHub 사용자명 입력
- **Password**: 복사한 Personal Access Token 붙여넣기

### 4-4. 성공 확인

푸시가 성공하면 다음과 같은 메시지가 나타납니다:
```
Enumerating objects: X, done.
Counting objects: 100% (X/X), done.
Writing objects: 100% (X/X), done.
To https://github.com/사용자명/저장소명.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

이제 GitHub 웹사이트에서 저장소를 새로고침하면 파일들이 업로드된 것을 확인할 수 있습니다!

## 문제 해결

### 오류: "remote origin already exists"
이미 원격 저장소가 설정되어 있다는 의미입니다.

**해결 방법:**
```powershell
# 기존 원격 저장소 제거
git remote remove origin

# 다시 추가
git remote add origin https://github.com/사용자명/저장소명.git
```

### 오류: "Support for password authentication was removed"
GitHub는 더 이상 비밀번호 인증을 지원하지 않습니다.

**해결 방법:**
- Personal Access Token을 사용해야 합니다 (위의 4-3 단계 참고)

### 오류: "fatal: not a git repository"
Git 저장소가 초기화되지 않았습니다.

**해결 방법:**
```powershell
git init
git add .
git commit -m "Initial commit"
```

### 오류: "Permission denied"
토큰 권한이 부족하거나 잘못된 토큰입니다.

**해결 방법:**
- Personal Access Token을 다시 생성하고 **repo** 권한을 확인하세요

## 전체 명령어 요약

```powershell
# 1. 폴더 이동
cd "C:\Users\ohdal\OneDrive\문서\03. Cursor\Yahoo Finance"

# 2. Git 초기화 (아직 안 했다면)
git init

# 3. 파일 추가
git add .

# 4. 커밋 (아직 안 했다면)
git commit -m "Initial commit: Yahoo Finance ETF crawler"

# 5. 원격 저장소 추가
git remote add origin https://github.com/사용자명/저장소명.git

# 6. 메인 브랜치 설정
git branch -M main

# 7. 푸시
git push -u origin main
```

## 시각적 가이드

### GitHub 저장소 URL 찾기

```
GitHub 저장소 페이지
┌─────────────────────────────────────┐
│  [Code] [Issues] [Pull requests]    │
│                                      │
│  ┌──────────────────────────────┐   │
│  │  [Code ▼]  ← 이 버튼 클릭!   │   │
│  └──────────────────────────────┘   │
│                                      │
│  팝업이 나타남:                      │
│  ┌──────────────────────────────┐   │
│  │ HTTPS  SSH  GitHub CLI       │   │
│  │                               │   │
│  │ https://github.com/...        │   │
│  │ [복사 버튼]                   │   │
│  └──────────────────────────────┘   │
└─────────────────────────────────────┘
```

### Personal Access Token 생성 위치

```
GitHub 웹사이트
┌─────────────────────────────────────┐
│ 프로필 사진 (우측 상단)              │
│   ↓                                  │
│ Settings                             │
│   ↓                                  │
│ 왼쪽 메뉴 맨 아래                    │
│ Developer settings                   │
│   ↓                                  │
│ Personal access tokens               │
│   ↓                                  │
│ Tokens (classic)                     │
│   ↓                                  │
│ Generate new token (classic)         │
└─────────────────────────────────────┘
```

## 도움이 더 필요하신가요?

문제가 계속되면 다음 정보를 알려주세요:
- 어떤 명령어를 실행했는지
- 어떤 오류 메시지가 나타났는지
- 어느 단계에서 막혔는지
