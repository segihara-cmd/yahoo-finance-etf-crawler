@echo off
chcp 65001 >nul
echo ========================================
echo GitHub 업로드 준비 스크립트
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

echo [1/4] Git 저장소 초기화...
git init
if errorlevel 1 (
    echo [오류] Git 초기화 실패
    pause
    exit /b 1
)

echo [2/4] .gitignore 확인...
if not exist .gitignore (
    echo [경고] .gitignore 파일이 없습니다.
)

echo [3/4] 파일 추가...
git add .
if errorlevel 1 (
    echo [오류] 파일 추가 실패
    pause
    exit /b 1
)

echo [4/4] 첫 번째 커밋 생성...
git commit -m "Initial commit: Yahoo Finance ETF crawler"
if errorlevel 1 (
    echo [경고] 커밋 실패 (이미 커밋된 파일이 있을 수 있습니다)
)

echo.
echo ========================================
echo 준비 완료!
echo ========================================
echo.
echo 다음 단계:
echo 1. GitHub에서 새 저장소를 만드세요
echo 2. 다음 명령어를 실행하세요:
echo.
echo    git remote add origin https://github.com/사용자명/저장소명.git
echo    git branch -M main
echo    git push -u origin main
echo.
echo 자세한 내용은 GITHUB_가이드.md 파일을 참고하세요.
echo.
pause
