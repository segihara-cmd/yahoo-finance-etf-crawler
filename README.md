# Yahoo Finance ETF Gainers 크롤링

Yahoo Finance의 ETF Gainers 페이지에서 데이터를 크롤링하여 엑셀 파일로 저장하는 스크립트입니다.

## 기능

- Yahoo Finance ETF Gainers 페이지에서 데이터 추출
- 다음 정보를 수집:
  - Symbol (심볼)
  - Name (이름)
  - Price (가격)
  - Change (변동액)
  - Change % (변동률)
  - Volume (거래량)
  - 50 Day Average (50일 평균)
  - 200 Day Average (200일 평균)
  - 3 Month Return (3개월 수익률)
  - YTD Return (연초 대비 수익률)
  - 52 Wk Change % (52주 변동률)
  - 52 Wk Range (52주 범위)

## 설치 방법

### 1. 필요한 패키지 설치

```bash
pip install -r requirements.txt
```

또는 개별 설치:

```bash
pip install requests beautifulsoup4 pandas openpyxl selenium webdriver-manager
```

### 2. 실행 방법

#### 방법 1: 배치 파일 실행 (Windows)
```
실행.bat
```

#### 방법 2: Python 스크립트 직접 실행

일반 버전 (requests + BeautifulSoup):
```bash
python crawl_etf_gainers.py
```

Selenium 버전 (동적 콘텐츠 처리):
```bash
python crawl_etf_gainers_selenium.py
```

## 파일 설명

- `crawl_etf_gainers.py`: requests와 BeautifulSoup을 사용한 크롤링 스크립트
- `crawl_etf_gainers_selenium.py`: Selenium을 사용한 크롤링 스크립트 (동적 콘텐츠 처리)
- `requirements.txt`: 필요한 Python 패키지 목록
- `실행.bat`: Windows용 실행 배치 파일

## 출력 파일

크롤링이 완료되면 현재 디렉토리에 다음 형식의 엑셀 파일이 생성됩니다:
- `ETF_Gainers_YYYYMMDD_HHMMSS.xlsx`

## 주의사항

1. Yahoo Finance는 동적 콘텐츠를 사용하므로, 일반 버전이 작동하지 않을 경우 Selenium 버전을 사용하세요.
2. Selenium 버전은 Chrome 브라우저가 설치되어 있어야 합니다.
3. 크롤링 시 서버에 부하를 주지 않도록 적절한 딜레이를 두고 사용하세요.
4. 무작위 값이나 불필요한 데이터는 자동으로 필터링됩니다.

## 문제 해결

### 일반 버전이 작동하지 않는 경우
- Selenium 버전을 사용하세요 (`crawl_etf_gainers_selenium.py`)

### Chrome 드라이버 오류
- `webdriver-manager`가 자동으로 Chrome 드라이버를 다운로드합니다.
- 수동으로 설치하려면 [ChromeDriver 다운로드](https://chromedriver.chromium.org/)

### 인코딩 오류
- Windows에서는 UTF-8 인코딩을 사용하도록 설정되어 있습니다.

## 라이선스

이 스크립트는 개인 사용 목적으로 제공됩니다.

