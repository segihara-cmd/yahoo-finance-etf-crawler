@echo off
chcp 65001 >nul
echo ========================================
echo GitHub 빠른 푸시 스크립트
echo ========================================
echo.

REM Git 설치 확인
git --version >nul 2>&1
if errorlevel 1 (
    echo [오류] Git이 설치되어 있지 않습니다.
    pause
    exit /b 1
)

echo [1/4] 파일 추가...
git add .
if errorlevel 1 (
    echo [오류] 파일 추가 실패
    pause
    exit /b 1
)
echo [성공] 파일 추가 완료

echo.
echo [2/4] 커밋 생성...
git commit -m "Update: Yahoo Finance ETF crawler files"
if errorlevel 1 (
    echo [경고] 커밋 실패 (변경사항이 없을 수 있습니다)
    REM 커밋이 실패해도 계속 진행
) else (
    echo [성공] 커밋 완료
)

echo.
echo [3/4] 원격 저장소 확인...
git remote -v >nul 2>&1
if errorlevel 1 (
    echo [오류] 원격 저장소가 설정되지 않았습니다.
    set /p REPO_URL="GitHub 저장소 URL을 입력하세요: "
    if not "%REPO_URL%"=="" (
        git remote add origin %REPO_URL%
    ) else (
        echo [오류] URL을 입력해야 합니다.
        pause
        exit /b 1
    )
)

echo.
echo [4/4] GitHub에 푸시...
echo.
echo [중요] 인증이 필요합니다:
echo - Username: GitHub 사용자명 입력
echo - Password: Personal Access Token 입력
echo.

git branch -M main >nul 2>&1
git push -u origin main

if errorlevel 1 (
    echo.
    echo [오류] 푸시 실패
    echo.
    echo 확인 사항:
    echo 1. Personal Access Token을 사용했는지 확인
    echo 2. 저장소 URL이 올바른지 확인: git remote -v
    echo 3. 커밋이 있는지 확인: git log
    echo.
) else (
    echo.
    echo ========================================
    echo 성공! GitHub에 업로드되었습니다!
    echo ========================================
    echo.
    echo 저장소를 새로고침하여 확인하세요:
    echo https://github.com/segihara-cmd/yahoo-finance-etf-crawler
    echo.
)

pause
