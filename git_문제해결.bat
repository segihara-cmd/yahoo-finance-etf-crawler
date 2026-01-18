@echo off
chcp 65001 >nul
echo ========================================
echo GitHub 푸시 문제 해결 스크립트
echo ========================================
echo.

REM Git 설치 확인
git --version >nul 2>&1
if errorlevel 1 (
    echo [오류] Git이 설치되어 있지 않습니다.
    pause
    exit /b 1
)

echo [1/6] 현재 상태 확인...
echo.
echo === Git 상태 ===
git status
echo.

echo === 원격 저장소 확인 ===
git remote -v
echo.

echo === 브랜치 확인 ===
git branch -a
echo.

echo === 최근 커밋 확인 ===
git log --oneline -5
echo.

pause

echo.
echo [2/6] 파일 확인...
if exist "crawl_etf_gainers.py" (
    echo [확인] crawl_etf_gainers.py 파일 존재
) else (
    echo [경고] crawl_etf_gainers.py 파일이 없습니다
)

if exist "README.md" (
    echo [확인] README.md 파일 존재
) else (
    echo [경고] README.md 파일이 없습니다
)

echo.
pause

echo.
echo [3/6] 파일 추가...
git add .
if errorlevel 1 (
    echo [오류] 파일 추가 실패
    pause
    exit /b 1
)
echo [성공] 파일 추가 완료

echo.
echo [4/6] 커밋 확인...
git status
echo.

REM 커밋되지 않은 파일이 있는지 확인
git diff --cached --quiet
if errorlevel 1 (
    echo [정보] 커밋되지 않은 파일이 있습니다. 커밋을 생성합니다...
    set /p COMMIT_MSG="커밋 메시지를 입력하세요 (Enter: 기본 메시지 사용): "
    if "%COMMIT_MSG%"=="" (
        set COMMIT_MSG=Initial commit: Yahoo Finance ETF crawler
    )
    git commit -m "%COMMIT_MSG%"
    if errorlevel 1 (
        echo [오류] 커밋 실패
        pause
        exit /b 1
    )
    echo [성공] 커밋 완료
) else (
    echo [정보] 모든 파일이 이미 커밋되어 있습니다.
)

echo.
echo [5/6] 원격 저장소 확인 및 설정...
git remote -v >nul 2>&1
if errorlevel 1 (
    echo [정보] 원격 저장소가 설정되지 않았습니다.
    set /p REPO_URL="GitHub 저장소 URL을 입력하세요: "
    if not "%REPO_URL%"=="" (
        git remote add origin %REPO_URL%
        echo [성공] 원격 저장소 추가 완료
    )
) else (
    echo [정보] 원격 저장소가 이미 설정되어 있습니다.
    git remote -v
)

echo.
echo [6/6] GitHub에 푸시...
echo.
echo [안내] 메인 브랜치를 확인하고 푸시합니다.
git branch -M main

echo.
echo [정보] 푸시를 시작합니다...
echo [중요] 인증이 필요합니다:
echo - Username: GitHub 사용자명 입력
echo - Password: Personal Access Token 입력
echo.

git push -u origin main

if errorlevel 1 (
    echo.
    echo [오류] 푸시 실패
    echo.
    echo 문제 해결 방법:
    echo 1. Personal Access Token을 사용했는지 확인
    echo 2. 저장소 URL이 올바른지 확인
    echo 3. 저장소에 접근 권한이 있는지 확인
    echo.
    echo 강제 푸시를 시도하시겠습니까? (권장하지 않음)
    set /p FORCE_PUSH="강제 푸시? [Y/N]: "
    if /i "%FORCE_PUSH%"=="Y" (
        git push -u origin main --force
    )
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
