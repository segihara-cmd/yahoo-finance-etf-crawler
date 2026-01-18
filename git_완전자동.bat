@echo off
chcp 65001 >nul
echo ========================================
echo GitHub 완전 자동 업로드 스크립트
echo ========================================
echo.

REM Git 설치 확인
git --version >nul 2>&1
if errorlevel 1 (
    echo [오류] Git이 설치되어 있지 않습니다.
    echo https://git-scm.com/downloads 에서 Git을 다운로드하세요.
    pause
    exit /b 1
)

echo [단계 1/6] Git 저장소 초기화...
if not exist .git (
    git init
    if errorlevel 1 (
        echo [오류] Git 초기화 실패
        pause
        exit /b 1
    )
    echo [성공] Git 저장소 초기화 완료
) else (
    echo [정보] Git 저장소가 이미 초기화되어 있습니다.
)

echo.
echo [단계 2/6] Git 사용자 정보 설정...
REM 사용자 정보 확인 (값이 있는지 확인)
git config user.name > temp_name.txt 2>&1
set /p EXISTING_NAME=<temp_name.txt
del temp_name.txt >nul 2>&1

git config user.email > temp_email.txt 2>&1
set /p EXISTING_EMAIL=<temp_email.txt
del temp_email.txt >nul 2>&1

if "%EXISTING_NAME%"=="" (
    echo [안내] Git 사용자 정보를 설정해야 합니다.
    set /p GIT_NAME="사용자 이름을 입력하세요 (예: Your Name): "
    set /p GIT_EMAIL="이메일을 입력하세요 (예: your.email@example.com): "
    if not "%GIT_NAME%"=="" (
        git config user.name "%GIT_NAME%"
        echo [성공] 사용자명 설정: %GIT_NAME%
    )
    if not "%GIT_EMAIL%"=="" (
        git config user.email "%GIT_EMAIL%"
        echo [성공] 이메일 설정: %GIT_EMAIL%
    )
    if "%GIT_NAME%"=="" (
        echo [오류] 사용자명을 입력해야 합니다.
        pause
        exit /b 1
    )
    if "%GIT_EMAIL%"=="" (
        echo [오류] 이메일을 입력해야 합니다.
        pause
        exit /b 1
    )
    echo [성공] 사용자 정보 설정 완료
) else (
    echo [정보] 사용자 정보가 이미 설정되어 있습니다.
    echo 사용자명: %EXISTING_NAME%
    echo 이메일: %EXISTING_EMAIL%
    if "%EXISTING_NAME%"=="" (
        echo [경고] 사용자명이 비어있습니다. 다시 설정합니다.
        set /p GIT_NAME="사용자 이름을 입력하세요 (예: Your Name): "
        if not "%GIT_NAME%"=="" (
            git config user.name "%GIT_NAME%"
            echo [성공] 사용자명 설정: %GIT_NAME%
        )
    )
    if "%EXISTING_EMAIL%"=="" (
        echo [경고] 이메일이 비어있습니다. 다시 설정합니다.
        set /p GIT_EMAIL="이메일을 입력하세요 (예: your.email@example.com): "
        if not "%GIT_EMAIL%"=="" (
            git config user.email "%GIT_EMAIL%"
            echo [성공] 이메일 설정: %GIT_EMAIL%
        )
    )
)

echo.
echo [단계 3/6] 파일 추가 및 커밋...
git add .
if errorlevel 1 (
    echo [오류] 파일 추가 실패
    pause
    exit /b 1
)

REM 커밋이 있는지 확인
git rev-parse --verify HEAD >nul 2>&1
if errorlevel 1 (
    echo [정보] 첫 번째 커밋을 생성합니다...
    git commit -m "Initial commit: Yahoo Finance ETF crawler"
    if errorlevel 1 (
        echo [오류] 커밋 실패 - 사용자 정보를 확인하세요
        pause
        exit /b 1
    )
    echo [성공] 첫 번째 커밋 완료
) else (
    REM 변경사항 확인
    git diff --quiet >nul 2>&1
    if errorlevel 1 (
        echo [정보] 변경사항을 커밋합니다...
        git commit -m "Update: Yahoo Finance ETF crawler files"
        echo [성공] 커밋 완료
    ) else (
        echo [정보] 커밋할 변경사항이 없습니다.
    )
)

echo.
echo [단계 4/6] GitHub 저장소 정보 입력...
echo.
set /p REPO_URL="GitHub 저장소 URL을 입력하세요 (예: https://github.com/사용자명/저장소명.git): "

if "%REPO_URL%"=="" (
    echo [오류] URL을 입력해야 합니다.
    pause
    exit /b 1
)

echo.
echo [단계 5/6] 원격 저장소 설정...
REM 기존 원격 저장소 제거
git remote remove origin >nul 2>&1

git remote add origin %REPO_URL%
if errorlevel 1 (
    echo [오류] 원격 저장소 추가 실패
    pause
    exit /b 1
)
echo [성공] 원격 저장소 설정 완료

echo.
echo [단계 6/6] GitHub 인증 정보 입력...
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

echo.
echo [정보] GitHub에 푸시를 시작합니다...
echo.

REM URL 파싱하여 인증 정보 포함
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
    echo 1. Personal Access Token이 올바른지 확인
    echo 2. 저장소 URL이 올바른지 확인
    echo 3. 저장소에 접근 권한이 있는지 확인
    echo.
    echo 수동으로 시도하려면:
    echo git push -u origin main
    echo (그리고 사용자명과 토큰을 입력)
) else (
    echo.
    echo ========================================
    echo 성공! GitHub에 업로드되었습니다!
    echo ========================================
    echo.
    echo 저장소 URL: %REPO_URL%
    echo.
    echo 웹 브라우저에서 확인하세요!
    echo.
)

pause
