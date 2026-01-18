@echo off
chcp 65001 >nul
echo ========================================
echo GitHub 푸시 스크립트
echo ========================================
echo.

REM Git 설치 확인
git --version >nul 2>&1
if errorlevel 1 (
    echo [오류] Git이 설치되어 있지 않습니다.
    pause
    exit /b 1
)

echo [안내] 이 스크립트는 GitHub에 파일을 업로드합니다.
echo.
echo 필요한 정보:
echo 1. GitHub 저장소 URL (예: https://github.com/사용자명/저장소명.git)
echo 2. Personal Access Token
echo.
pause

REM 원격 저장소 URL 입력
set /p REPO_URL="GitHub 저장소 URL을 입력하세요: "

if "%REPO_URL%"=="" (
    echo [오류] URL을 입력해야 합니다.
    pause
    exit /b 1
)

echo.
echo [1/5] Git 저장소 확인...
if not exist .git (
    echo [정보] Git 저장소가 초기화되지 않았습니다. 초기화를 진행합니다...
    git init
    if errorlevel 1 (
        echo [오류] Git 초기화 실패
        pause
        exit /b 1
    )
    echo [정보] Git 저장소 초기화 완료
) else (
    echo [정보] Git 저장소가 이미 초기화되어 있습니다.
)

echo [2/5] Git 사용자 정보 확인...
git config user.name >nul 2>&1
if errorlevel 1 (
    echo [안내] Git 사용자 정보를 설정해야 합니다.
    set /p GIT_NAME="사용자 이름을 입력하세요 (예: Your Name): "
    set /p GIT_EMAIL="이메일을 입력하세요 (예: your.email@example.com): "
    if not "%GIT_NAME%"=="" (
        git config user.name "%GIT_NAME%"
    )
    if not "%GIT_EMAIL%"=="" (
        git config user.email "%GIT_EMAIL%"
    )
    echo [정보] 사용자 정보 설정 완료
) else (
    echo [정보] 사용자 정보가 이미 설정되어 있습니다.
)

echo [3/5] 파일 추가 및 커밋 확인...
git status >nul 2>&1
if errorlevel 1 (
    echo [오류] Git 저장소에 문제가 있습니다.
    pause
    exit /b 1
)

REM 커밋되지 않은 파일이 있는지 확인
git diff --quiet >nul 2>&1
if errorlevel 1 (
    echo [정보] 커밋되지 않은 변경사항이 있습니다. 파일을 추가합니다...
    git add .
    git commit -m "Update: Yahoo Finance ETF crawler files"
    if errorlevel 1 (
        echo [경고] 커밋 실패 (변경사항이 없을 수 있습니다)
    ) else (
        echo [정보] 파일 커밋 완료
    )
) else (
    REM 커밋이 하나도 없는지 확인
    git rev-parse --verify HEAD >nul 2>&1
    if errorlevel 1 (
        echo [정보] 첫 번째 커밋을 생성합니다...
        git add .
        git commit -m "Initial commit: Yahoo Finance ETF crawler"
        if errorlevel 1 (
            echo [오류] 커밋 실패 - 사용자 정보를 확인하세요
            pause
            exit /b 1
        ) else (
            echo [정보] 첫 번째 커밋 완료
        )
    ) else (
        echo [정보] 모든 파일이 이미 커밋되어 있습니다.
    )
)

echo [4/5] 원격 저장소 확인...
git remote -v >nul 2>&1
if errorlevel 1 (
    echo [정보] 원격 저장소가 설정되지 않았습니다.
) else (
    echo [정보] 기존 원격 저장소를 제거합니다...
    git remote remove origin
)

echo [5/5] 원격 저장소 추가...
git remote add origin %REPO_URL%
if errorlevel 1 (
    echo [오류] 원격 저장소 추가 실패
    pause
    exit /b 1
)

echo.
echo ========================================
echo GitHub 인증 정보 입력
echo ========================================
echo.
echo [중요] Personal Access Token이 필요합니다.
echo.
echo Personal Access Token 생성 방법:
echo 1. GitHub 웹사이트 접속
echo 2. 우측 상단 프로필 사진 클릭
echo 3. Settings → Developer settings
echo 4. Personal access tokens → Tokens (classic)
echo 5. Generate new token (classic)
echo 6. repo 권한 체크 후 생성
echo.
set /p GIT_USERNAME="GitHub 사용자명을 입력하세요: "
set /p GIT_TOKEN="Personal Access Token을 입력하세요: "

if "%GIT_USERNAME%"=="" (
    echo [오류] 사용자명을 입력해야 합니다.
    pause
    exit /b 1
)

if "%GIT_TOKEN%"=="" (
    echo [오류] Personal Access Token을 입력해야 합니다.
    pause
    exit /b 1
)

echo.
echo [정보] 메인 브랜치 설정...
git branch -M main
if errorlevel 1 (
    echo [경고] 브랜치 설정 실패 (이미 main일 수 있습니다)
)

echo [정보] GitHub에 푸시를 시작합니다...
echo.

REM URL에 사용자명과 토큰을 포함하여 푸시
for /f "tokens=1,2,3 delims=/" %%a in ("%REPO_URL%") do set PROTOCOL=%%a
for /f "tokens=1,2,3 delims=/" %%a in ("%REPO_URL%") do set DOMAIN=%%b
for /f "tokens=1,2,3 delims=/" %%a in ("%REPO_URL%") do set PATH_PART=%%c

set PUSH_URL=%PROTOCOL%//%GIT_USERNAME%:%GIT_TOKEN%@%DOMAIN%/%PATH_PART%

git push -u %PUSH_URL% main

if errorlevel 1 (
    echo.
    echo [오류] 푸시 실패
    echo.
    echo 문제 해결:
    echo 1. Personal Access Token을 사용했는지 확인
    echo 2. 저장소 URL이 올바른지 확인
    echo 3. GitHub_업로드_상세가이드.md 파일을 참고하세요
) else (
    echo.
    echo ========================================
    echo 성공! GitHub에 업로드되었습니다!
    echo ========================================
    echo.
    echo 저장소 URL: %REPO_URL%
    echo.
)

pause
