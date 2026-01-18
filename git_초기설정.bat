@echo off
chcp 65001 >nul
echo ========================================
echo Git 초기 설정 스크립트
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

echo [1/3] Git 저장소 초기화...
if not exist .git (
    git init
    if errorlevel 1 (
        echo [오류] Git 초기화 실패
        pause
        exit /b 1
    )
    echo [성공] Git 저장소가 초기화되었습니다.
) else (
    echo [정보] Git 저장소가 이미 초기화되어 있습니다.
)

echo.
echo [2/3] 사용자 정보 확인...
git config user.name >nul 2>&1
if errorlevel 1 (
    echo [안내] Git 사용자 정보를 설정해야 합니다.
    set /p GIT_NAME="사용자 이름을 입력하세요 (예: Your Name): "
    set /p GIT_EMAIL="이메일을 입력하세요 (예: your.email@example.com): "
    git config --global user.name "%GIT_NAME%"
    git config --global user.email "%GIT_EMAIL%"
    echo [성공] 사용자 정보가 설정되었습니다.
) else (
    echo [정보] 사용자 정보가 이미 설정되어 있습니다.
    echo 사용자명: 
    git config user.name
    echo 이메일: 
    git config user.email
)

echo.
echo [3/3] 파일 추가 및 커밋...
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
) else (
    echo [정보] 변경사항을 커밋합니다...
    git commit -m "Update: Yahoo Finance ETF crawler files"
)

if errorlevel 1 (
    echo [경고] 커밋 실패 (변경사항이 없을 수 있습니다)
) else (
    echo [성공] 커밋이 완료되었습니다.
)

echo.
echo ========================================
echo 초기 설정 완료!
echo ========================================
echo.
echo 다음 단계:
echo 1. GitHub에서 새 저장소를 만드세요
echo 2. git_push.bat 파일을 실행하세요
echo    또는 다음 명령어를 실행하세요:
echo.
echo    git remote add origin https://github.com/사용자명/저장소명.git
echo    git branch -M main
echo    git push -u origin main
echo.
pause
