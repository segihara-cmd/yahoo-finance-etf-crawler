# GitHub에서 업로드한 파일 확인하기

## 방법 1: 웹 브라우저에서 확인 (가장 쉬움)

### 1단계: GitHub 저장소 페이지 접속

1. 웹 브라우저를 엽니다 (Chrome, Edge, Firefox 등)
2. 주소창에 다음 URL을 입력합니다:
   ```
   https://github.com/segihara-cmd/yahoo-finance-etf-crawler
   ```
   또는
   - GitHub 메인 페이지 (https://github.com) 접속
   - 우측 상단 프로필 사진 클릭
   - "Your repositories" 클릭
   - "yahoo-finance-etf-crawler" 저장소 클릭

### 2단계: 파일 목록 확인

저장소 페이지에서 다음을 확인할 수 있습니다:

- **파일 목록**: 저장소의 모든 파일과 폴더가 표시됩니다
- **README.md**: 프로젝트 설명이 표시됩니다
- **파일 클릭**: 파일을 클릭하면 내용을 볼 수 있습니다

### 3단계: 파일 내용 보기

1. 파일 이름을 클릭하면 파일 내용을 볼 수 있습니다
2. 코드 하이라이팅이 적용되어 읽기 쉽습니다
3. 파일 상단의 연필 아이콘(✏️)을 클릭하면 편집할 수 있습니다

## 방법 2: GitHub Desktop 앱 사용

1. [GitHub Desktop](https://desktop.github.com/) 다운로드 및 설치
2. GitHub 계정으로 로그인
3. File → Clone repository → 저장소 선택
4. 로컬 컴퓨터에서 파일 확인 및 편집 가능

## 방법 3: Git 명령어로 로컬에 다운로드

다른 컴퓨터에서 파일을 받으려면:

```bash
git clone https://github.com/segihara-cmd/yahoo-finance-etf-crawler.git
```

## 저장소 페이지에서 확인할 수 있는 정보

### 메인 페이지
- **Code 탭**: 모든 파일과 폴더
- **Issues 탭**: 버그 리포트 및 기능 제안
- **Pull requests 탭**: 코드 변경 요청
- **Actions 탭**: 자동화 작업 (CI/CD)
- **Settings 탭**: 저장소 설정

### 파일 탐색
- 폴더 클릭: 하위 폴더로 이동
- 파일 클릭: 파일 내용 보기
- History 버튼: 파일 변경 이력 보기
- Raw 버튼: 원본 파일 다운로드

## 빠른 접근 링크

저장소 URL을 북마크에 추가하면 쉽게 접근할 수 있습니다:
```
https://github.com/segihara-cmd/yahoo-finance-etf-crawler
```

## 파일이 보이지 않는다면?

1. **페이지 새로고침**: F5 키 또는 Ctrl + R
2. **브라우저 캐시 삭제**: Ctrl + Shift + Delete
3. **다른 브라우저에서 확인**: Chrome, Edge 등
4. **푸시가 완료되었는지 확인**: PowerShell에서 `git status` 실행

## 업로드된 파일 목록 확인

저장소 페이지에서 다음 파일들이 보여야 합니다:

- `crawl_etf_gainers.py`
- `crawl_etf_gainers_selenium.py`
- `requirements.txt`
- `README.md`
- `.gitignore`
- 기타 설정 파일들

**참고**: `.xlsx` 파일은 `.gitignore`에 의해 업로드되지 않았습니다 (의도된 동작).
