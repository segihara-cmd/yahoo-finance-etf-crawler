# -*- coding: utf-8 -*-
"""엑셀 파일 생성 테스트"""

import pandas as pd
from datetime import datetime
from pathlib import Path
import os

# 샘플 데이터 생성
data = [
    {
        'Symbol': 'APLX',
        'Name': 'Tradr 2X Long APLD Daily ETF',
        'Price': 113.63,
        'Change': 29.73,
        'Change %': 35.44,
        'Volume': 905902,
        '50 Day Average': 75.79,
        '200 Day Average': 80.55,
        '3 Month Return': None,
        'YTD Return': None,
        '52 Wk Change %': 283.89,
        '52 Wk Range': '2.31 - 53.43'
    },
    {
        'Symbol': 'OPEX',
        'Name': 'Tradr 2X Long OPEN Daily ETF',
        'Price': 21.00,
        'Change': 4.67,
        'Change %': 28.60,
        'Volume': 1255000,
        '50 Day Average': 22.46,
        '200 Day Average': 23.17,
        '3 Month Return': None,
        'YTD Return': None,
        '52 Wk Change %': -20.90,
        '52 Wk Range': '6.26 - 25.70'
    }
]

# 현재 스크립트가 있는 디렉토리에 저장
script_dir = Path(__file__).parent.absolute()
timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
filename = f"ETF_Gainers_{timestamp}.xlsx"
filepath = script_dir / filename

# DataFrame 생성
df = pd.DataFrame(data)

# 엑셀 파일로 저장
df.to_excel(filepath, index=False, engine='openpyxl')

print(f"엑셀 파일 저장 완료!")
print(f"경로: {filepath}")
print(f"총 {len(data)}개의 ETF 데이터가 저장되었습니다.")
print(f"\n파일이 생성되었는지 확인: {filepath.exists()}")
