@echo off
chcp 65001 >nul
echo ========================================
echo GitHub에서 최신 코드 가져오기
echo ========================================
echo.
echo [안내] GitHub 저장소의 최신 변경사항을 가져옵니다.
echo.

REM Git 설치 확인
git --version >nul 2>&1
if errorlevel 1 (
    echo [오류] Git이 설치되어 있지 않습니다.
    pause
    exit /b 1
)

echo [1/3] 원격 저장소 확인...
git remote -v >nul 2>&1
if errorlevel 1 (
    echo [오류] 원격 저장소가 설정되지 않았습니다.
    set /p REPO_URL="GitHub 저장소 URL을 입력하세요: "
    if not "%REPO_URL%"=="" (
        git remote add origin %REPO_URL%
        echo [성공] 원격 저장소 추가 완료
    ) else (
        echo [오류] URL을 입력해야 합니다.
        pause
        exit /b 1
    )
) else (
    echo [정보] 원격 저장소가 설정되어 있습니다.
    git remote -v
)

echo.
echo [2/3] 최신 정보 가져오기...
git fetch origin
if errorlevel 1 (
    echo [경고] fetch 실패 (인터넷 연결 확인)
) else (
    echo [성공] 최신 정보 가져오기 완료
)

echo.
echo [3/3] 변경사항 병합...
git pull origin main
if errorlevel 1 (
    echo.
    echo [오류] Pull 실패
    echo.
    echo 가능한 원인:
    echo 1. 로컬에 커밋되지 않은 변경사항이 있음
    echo 2. 충돌(conflict)이 발생함
    echo.
    echo 해결 방법:
    echo 1. 로컬 변경사항을 먼저 커밋: git_빠른푸시.bat 실행
    echo 2. 또는 변경사항을 저장: git stash
    echo 3. 그 다음 다시 pull 시도
    echo.
) else (
    echo.
    echo ========================================
    echo 성공! 최신 코드를 가져왔습니다!
    echo ========================================
    echo.
    echo 변경된 파일을 확인하세요.
    echo.
)

pause
