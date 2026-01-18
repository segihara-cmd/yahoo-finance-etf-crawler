@echo off
chcp 65001 >nul
echo ========================================
echo Yahoo Finance ETF 크롤링 실행
echo ========================================
echo.

REM 가상환경 확인 및 생성
if not exist "venv" (
    echo 가상환경 생성 중...
    python -m venv venv
)

REM 가상환경 활성화
call venv\Scripts\activate.bat

REM 패키지 설치
echo 패키지 설치 중...
pip install -r requirements.txt

echo.
echo ========================================
echo 크롤링 시작
echo ========================================
echo.

REM 먼저 일반 버전 시도
python crawl_etf_gainers.py

REM 실패하면 Selenium 버전 시도
if errorlevel 1 (
    echo.
    echo 일반 버전 실패, Selenium 버전으로 재시도...
    python crawl_etf_gainers_selenium.py
)

echo.
echo ========================================
echo 완료
echo ========================================
pause

