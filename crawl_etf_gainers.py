# -*- coding: utf-8 -*-
"""
Yahoo Finance ETF Gainers 크롤링 스크립트
https://finance.yahoo.com/markets/etfs/gainers/?start=0&count=25
"""

import requests
from bs4 import BeautifulSoup
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

def parse_range(text):
    """52주 범위 파싱"""
    if not text:
        return None, None
    
    # labels에서 범위 추출
    # 예: <span>2.31</span> <span>53.43</span>
    soup = BeautifulSoup(str(text), 'html.parser')
    spans = soup.find_all('span')
    
    if len(spans) >= 2:
        try:
            low = float(spans[0].text.strip().replace(',', ''))
            high = float(spans[1].text.strip().replace(',', ''))
            return f"{low} - {high}"
        except:
            return None
    
    return None

def crawl_etf_gainers(url, start=0, count=25):
    """ETF Gainers 데이터 크롤링"""
    
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
    }
    
    # URL에 파라미터 추가
    full_url = f"{url}?start={start}&count={count}"
    
    print(f"크롤링 시작: {full_url}")
    
    try:
        response = requests.get(full_url, headers=headers, timeout=30)
        response.raise_for_status()
        
        soup = BeautifulSoup(response.content, 'html.parser')
        
        # 테이블 찾기
        table = soup.find('table', class_='yf-1uayyp1')
        if not table:
            print("테이블을 찾을 수 없습니다.")
            return None
        
        # 데이터 추출
        rows = table.find_all('tr', {'data-testid': 'data-table-v2-row'})
        print(f"발견된 행 수: {len(rows)}")
        
        data = []
        
        for row in rows:
            try:
                # Symbol
                symbol_cell = row.find('td', {'data-testid-cell': 'ticker'})
                symbol = ""
                if symbol_cell:
                    symbol_link = symbol_cell.find('a', {'data-testid': 'table-cell-ticker'})
                    if symbol_link:
                        symbol_span = symbol_link.find('span', class_='symbol')
                        if symbol_span:
                            symbol = clean_text(symbol_span.text)
                
                # Name
                name_cell = row.find('td', {'data-testid-cell': 'companyshortname.raw'})
                name = ""
                if name_cell:
                    name_div = name_cell.find('div', class_='leftAlignHeader')
                    if name_div:
                        name = clean_text(name_div.get('title', '') or name_div.text)
                
                # Price
                price_cell = row.find('td', {'data-testid-cell': 'intradayprice'})
                price = None
                if price_cell:
                    price_span = price_cell.find('span', {'data-testid': 'change'})
                    if price_span:
                        price = parse_number(price_span.text)
                
                # Change
                change_cell = row.find('td', {'data-testid-cell': 'intradaypricechange'})
                change = None
                if change_cell:
                    change_span = change_cell.find('span', {'data-testid': 'colorChange'})
                    if change_span:
                        change = parse_number(change_span.text, keep_sign=True)
                
                # Change %
                change_pct_cell = row.find('td', {'data-testid-cell': 'percentchange'})
                change_pct = None
                if change_pct_cell:
                    change_pct_span = change_pct_cell.find('span', {'data-testid': 'colorChange'})
                    if change_pct_span:
                        change_pct = parse_percentage(change_pct_span.text)
                
                # Volume
                volume_cell = row.find('td', {'data-testid-cell': 'dayvolume'})
                volume = None
                if volume_cell:
                    volume_span = volume_cell.find('span', {'data-testid': 'change'})
                    if volume_span:
                        volume = parse_number(volume_span.text)
                
                # 50 Day Average
                avg50_cell = row.find('td', {'data-testid-cell': 'fiftydaymovingavg'})
                avg50 = None
                if avg50_cell:
                    avg50 = parse_number(avg50_cell.text)
                
                # 200 Day Average
                avg200_cell = row.find('td', {'data-testid-cell': 'twohundreddaymovingavg'})
                avg200 = None
                if avg200_cell:
                    avg200 = parse_number(avg200_cell.text)
                
                # 3 Month Return
                return3m_cell = row.find('td', {'data-testid-cell': 'trailing_3m_return'})
                return3m = None
                if return3m_cell:
                    return3m_span = return3m_cell.find('span', {'data-testid': 'colorChange'})
                    if return3m_span:
                        return3m = parse_percentage(return3m_span.text)
                
                # YTD Return
                ytd_cell = row.find('td', {'data-testid-cell': 'trailing_ytd_return'})
                ytd = None
                if ytd_cell:
                    ytd_span = ytd_cell.find('span', {'data-testid': 'colorChange'})
                    if ytd_span:
                        ytd = parse_percentage(ytd_span.text)
                
                # 52 Wk Change %
                wk52_cell = row.find('td', {'data-testid-cell': 'fiftytwowkpercentchange'})
                wk52 = None
                if wk52_cell:
                    wk52_span = wk52_cell.find('span', {'data-testid': 'colorChange'})
                    if wk52_span:
                        wk52 = parse_percentage(wk52_span.text)
                
                # 52 Wk Range
                range52_cell = row.find('td', {'data-testid-cell': 'fiftyTwoWeekRange'})
                range52 = None
                if range52_cell:
                    range_div = range52_cell.find('div', class_='labels')
                    if range_div:
                        range52 = parse_range(range_div)
                
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
    
    except requests.exceptions.RequestException as e:
        print(f"요청 오류: {e}")
        return None
    except Exception as e:
        print(f"크롤링 오류: {e}")
        return None

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
    print("Yahoo Finance ETF Gainers 크롤링 시작")
    print("=" * 60)
    
    # 크롤링 실행
    data = crawl_etf_gainers(url, start=0, count=25)
    
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

