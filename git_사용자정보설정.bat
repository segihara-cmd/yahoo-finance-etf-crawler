@echo off
chcp 65001 >nul
echo ========================================
echo Git 사용자 정보 설정
echo ========================================
echo.

REM Git 설치 확인
git --version >nul 2>&1
if errorlevel 1 (
    echo [오류] Git이 설치되어 있지 않습니다.
    pause
    exit /b 1
)

echo [안내] Git 사용자 정보를 설정합니다.
echo.
echo 이 정보는 커밋할 때 사용됩니다.
echo.

set /p GIT_NAME="사용자 이름을 입력하세요 (예: Your Name): "
set /p GIT_EMAIL="이메일을 입력하세요 (예: your.email@example.com): "

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

echo.
echo [정보] 사용자 정보를 설정합니다...

REM 로컬 저장소에만 설정 (이 폴더에만 적용)
git config user.name "%GIT_NAME%"
git config user.email "%GIT_EMAIL%"

REM 전역 설정도 할지 물어보기
echo.
set /p SET_GLOBAL="전역 설정도 하시겠습니까? (모든 Git 프로젝트에 적용) [Y/N]: "
if /i "%SET_GLOBAL%"=="Y" (
    git config --global user.name "%GIT_NAME%"
    git config --global user.email "%GIT_EMAIL%"
    echo [성공] 전역 설정 완료
)

echo.
echo ========================================
echo 설정 완료!
echo ========================================
echo.
echo 사용자명: %GIT_NAME%
echo 이메일: %GIT_EMAIL%
echo.
echo 이제 git_완전자동.bat를 실행할 수 있습니다.
echo.
pause
