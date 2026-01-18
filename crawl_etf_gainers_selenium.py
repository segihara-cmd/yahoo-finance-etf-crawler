# -*- coding: utf-8 -*-
"""
Yahoo Finance ETF Gainers 크롤링 스크립트 (Selenium 버전)
동적 콘텐츠를 로드하는 사이트에 적합
"""

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
import pandas as pd
from datetime import datetime
import time
import re

def clean_text(text):
    """텍스트 정리 함수"""
    if not text:
        return ""
    return text.strip().replace('\n', '').replace('\t', '')

def parse_number(text, keep_sign=False):
    """숫자 문자열을 파싱 (M, K 등 처리)"""
    if not text or text == "--" or text == "":
        return None
    
    text = clean_text(text)
    
    # 부호 추출
    is_negative = text.startswith('-')
    if not keep_sign:
        # +, - 기호 제거 (기본값)
        text = text.replace('+', '').replace('-', '')
    
    # M (백만), K (천) 처리
    if 'M' in text:
        try:
            value = float(text.replace('M', '').replace(',', '')) * 1000000
            return -value if is_negative and keep_sign else value
        except:
            return None
    elif 'K' in text:
        try:
            value = float(text.replace('K', '').replace(',', '')) * 1000
            return -value if is_negative and keep_sign else value
        except:
            return None
    else:
        try:
            value = float(text.replace(',', ''))
            return -value if is_negative and keep_sign else value
        except:
            return None

def parse_percentage(text):
    """퍼센트 문자열을 파싱"""
    if not text or text == "--" or text == "":
        return None
    
    text = clean_text(text)
    # +, - 기호 제거
    text = text.replace('+', '').replace('%', '').replace(',', '')
    
    try:
        return float(text)
    except:
        return None

def parse_range(labels_text):
    """52주 범위 파싱"""
    if not labels_text:
        return None
    
    # 범위 텍스트에서 숫자 추출
    # 예: "2.31 53.43" 또는 "2.31\n53.43"
    numbers = re.findall(r'[\d.]+', labels_text)
    if len(numbers) >= 2:
        try:
            low = float(numbers[0])
            high = float(numbers[1])
            return f"{low} - {high}"
        except:
            return None
    
    return None

def crawl_etf_gainers_selenium(url, start=0, count=25):
    """ETF Gainers 데이터 크롤링 (Selenium 사용)"""
    
    # Chrome 옵션 설정
    chrome_options = Options()
    chrome_options.add_argument('--headless')  # 브라우저 창 숨기기
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--disable-dev-shm-usage')
    chrome_options.add_argument('--disable-blink-features=AutomationControlled')
    chrome_options.add_experimental_option("excludeSwitches", ["enable-automation"])
    chrome_options.add_experimental_option('useAutomationExtension', False)
    chrome_options.add_argument('user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36')
    
    # WebDriver 설정
    service = Service(ChromeDriverManager().install())
    driver = webdriver.Chrome(service=service, options=chrome_options)
    
    try:
        # URL에 파라미터 추가
        full_url = f"{url}?start={start}&count={count}"
        print(f"크롤링 시작: {full_url}")
        
        driver.get(full_url)
        
        # 페이지 로딩 대기
        wait = WebDriverWait(driver, 20)
        
        # 테이블이 로드될 때까지 대기
        wait.until(EC.presence_of_element_located((By.TAG_NAME, "table")))
        time.sleep(3)  # 추가 대기 시간
        
        # 테이블 찾기
        rows = driver.find_elements(By.CSS_SELECTOR, 'tr[data-testid="data-table-v2-row"]')
        print(f"발견된 행 수: {len(rows)}")
        
        data = []
        
        for row in rows:
            try:
                # Symbol
                symbol = ""
                try:
                    symbol_elem = row.find_element(By.CSS_SELECTOR, 'td[data-testid-cell="ticker"] span.symbol')
                    symbol = clean_text(symbol_elem.text)
                except:
                    pass
                
                # Name
                name = ""
                try:
                    name_elem = row.find_element(By.CSS_SELECTOR, 'td[data-testid-cell="companyshortname.raw"] div.leftAlignHeader')
                    name = clean_text(name_elem.get_attribute('title') or name_elem.text)
                except:
                    pass
                
                # Price
                price = None
                try:
                    price_elem = row.find_element(By.CSS_SELECTOR, 'td[data-testid-cell="intradayprice"] span[data-testid="change"]')
                    price = parse_number(price_elem.text)
                except:
                    pass
                
                # Change
                change = None
                try:
                    change_elem = row.find_element(By.CSS_SELECTOR, 'td[data-testid-cell="intradaypricechange"] span[data-testid="colorChange"]')
                    change = parse_number(change_elem.text, keep_sign=True)
                except:
                    pass
                
                # Change %
                change_pct = None
                try:
                    change_pct_elem = row.find_element(By.CSS_SELECTOR, 'td[data-testid-cell="percentchange"] span[data-testid="colorChange"]')
                    change_pct = parse_percentage(change_pct_elem.text)
                except:
                    pass
                
                # Volume
                volume = None
                try:
                    volume_elem = row.find_element(By.CSS_SELECTOR, 'td[data-testid-cell="dayvolume"] span[data-testid="change"]')
                    volume = parse_number(volume_elem.text)
                except:
                    pass
                
                # 50 Day Average
                avg50 = None
                try:
                    avg50_elem = row.find_element(By.CSS_SELECTOR, 'td[data-testid-cell="fiftydaymovingavg"]')
                    avg50 = parse_number(avg50_elem.text)
                except:
                    pass
                
                # 200 Day Average
                avg200 = None
                try:
                    avg200_elem = row.find_element(By.CSS_SELECTOR, 'td[data-testid-cell="twohundreddaymovingavg"]')
                    avg200 = parse_number(avg200_elem.text)
                except:
                    pass
                
                # 3 Month Return
                return3m = None
                try:
                    return3m_elem = row.find_element(By.CSS_SELECTOR, 'td[data-testid-cell="trailing_3m_return"] span[data-testid="colorChange"]')
                    return3m = parse_percentage(return3m_elem.text)
                except:
                    pass
                
                # YTD Return
                ytd = None
                try:
                    ytd_elem = row.find_element(By.CSS_SELECTOR, 'td[data-testid-cell="trailing_ytd_return"] span[data-testid="colorChange"]')
                    ytd = parse_percentage(ytd_elem.text)
                except:
                    pass
                
                # 52 Wk Change %
                wk52 = None
                try:
                    wk52_elem = row.find_element(By.CSS_SELECTOR, 'td[data-testid-cell="fiftytwowkpercentchange"] span[data-testid="colorChange"]')
                    wk52 = parse_percentage(wk52_elem.text)
                except:
                    pass
                
                # 52 Wk Range
                range52 = None
                try:
                    range_elem = row.find_element(By.CSS_SELECTOR, 'td[data-testid-cell="fiftyTwoWeekRange"] div.labels')
                    range52 = parse_range(range_elem.text)
                except:
                    pass
                
                # 데이터가 있는 경우만 추가
                if symbol:
                    data.append({
                        'Symbol': symbol,
                        'Name': name,
                        'Price': price,
                        'Change': change,
                        'Change %': change_pct,
                        'Volume': volume,
                        '50 Day Average': avg50,
                        '200 Day Average': avg200,
                        '3 Month Return': return3m,
                        'YTD Return': ytd,
                        '52 Wk Change %': wk52,
                        '52 Wk Range': range52
                    })
                    print(f"추출 완료: {symbol} - {name}")
            
            except Exception as e:
                print(f"행 처리 중 오류: {e}")
                continue
        
        return data
    
    except Exception as e:
        print(f"크롤링 오류: {e}")
        return None
    
    finally:
        driver.quit()

def save_to_excel(data, filename=None):
    """데이터를 엑셀 파일로 저장"""
    if not data:
        print("저장할 데이터가 없습니다.")
        return
    
    import os
    from pathlib import Path
    
    # 현재 스크립트가 있는 디렉토리에 저장
    script_dir = Path(__file__).parent.absolute()
    
    if filename is None:
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"ETF_Gainers_{timestamp}.xlsx"
    
    # 전체 경로 생성
    filepath = script_dir / filename
    
    df = pd.DataFrame(data)
    
    # 엑셀 파일로 저장
    df.to_excel(filepath, index=False, engine='openpyxl')
    print(f"\n엑셀 파일 저장 완료: {filepath}")
    print(f"총 {len(data)}개의 ETF 데이터가 저장되었습니다.")

def main():
    """메인 함수"""
    url = "https://finance.yahoo.com/markets/etfs/gainers/"
    
    print("=" * 60)
    print("Yahoo Finance ETF Gainers 크롤링 시작 (Selenium 버전)")
    print("=" * 60)
    
    # 크롤링 실행
    data = crawl_etf_gainers_selenium(url, start=0, count=25)
    
    if data:
        # 엑셀 파일로 저장
        save_to_excel(data)
        
        # 요약 정보 출력
        print("\n" + "=" * 60)
        print("크롤링 요약")
        print("=" * 60)
        print(f"총 {len(data)}개의 ETF 데이터를 추출했습니다.")
        
        if data:
            print("\n상위 5개 ETF:")
            for i, item in enumerate(data[:5], 1):
                print(f"{i}. {item['Symbol']} - {item['Name']} ({item['Change %']}%)")
    else:
        print("데이터를 가져오지 못했습니다.")

if __name__ == "__main__":
    main()

