# GitHub에서 코드 가져오기 (Pull) 가이드

## Pull이란?

**Pull**은 GitHub 저장소의 최신 변경사항을 로컬 컴퓨터로 가져오는 작업입니다.

- 다른 컴퓨터에서 수정한 코드를 가져올 때
- GitHub 웹사이트에서 직접 수정한 내용을 가져올 때
- 다른 사람이 업데이트한 코드를 가져올 때

## 사용 방법

### 방법 1: 배치 파일 사용 (가장 쉬움)

```
git_빠른가져오기.bat 더블클릭
```

→ 자동으로 GitHub에서 최신 코드를 가져옵니다.

### 방법 2: PowerShell에서 직접 실행

```powershell
# 1. 폴더 이동
cd "C:\Users\ohdal\OneDrive\문서\03. Cursor\Yahoo Finance"

# 2. GitHub에서 최신 코드 가져오기
git pull origin main
```

## Pull 과정 설명

### 1. Fetch (가져오기)
```
git fetch origin
```
→ 원격 저장소의 최신 정보를 가져옵니다 (아직 병합하지 않음)

### 2. Pull (가져오기 + 병합)
```
git pull origin main
```
→ 최신 코드를 가져와서 로컬 코드와 자동으로 병합합니다

## 일반적인 사용 시나리오

### 시나리오 1: 다른 컴퓨터에서 작업한 경우

1. 집 컴퓨터에서 코드 수정 → GitHub에 푸시
2. 회사 컴퓨터에서 `git_빠른가져오기.bat` 실행
3. 최신 코드가 로컬에 반영됨

### 시나리오 2: GitHub 웹사이트에서 수정한 경우

1. GitHub 웹사이트에서 README.md 수정
2. 로컬에서 `git_빠른가져오기.bat` 실행
3. 수정된 README.md가 로컬에 반영됨

### 시나리오 3: 협업하는 경우

1. 팀원이 코드를 수정하고 GitHub에 푸시
2. 내가 `git_빠른가져오기.bat` 실행
3. 팀원의 변경사항이 내 로컬에 반영됨

## 문제 해결

### 오류: "Your local changes would be overwritten"

**원인**: 로컬에 커밋되지 않은 변경사항이 있음

**해결 방법 1**: 변경사항을 먼저 커밋
```powershell
git add .
git commit -m "로컬 변경사항 저장"
git pull origin main
```

**해결 방법 2**: 변경사항을 임시 저장 (stash)
```powershell
git stash
git pull origin main
git stash pop  # 나중에 변경사항 다시 적용
```

### 오류: "Merge conflict"

**원인**: 같은 파일의 같은 부분을 수정해서 충돌 발생

**해결 방법**:
1. 충돌이 발생한 파일을 열어서 수정
2. `<<<<<<<`, `=======`, `>>>>>>>` 표시를 찾아서 수동으로 병합
3. 저장 후:
```powershell
git add .
git commit -m "충돌 해결"
```

### 오류: "fatal: not a git repository"

**원인**: Git 저장소가 초기화되지 않음

**해결 방법**:
```powershell
git init
git remote add origin https://github.com/segihara-cmd/yahoo-finance-etf-crawler.git
git pull origin main
```

## Pull vs Fetch

### Pull
- 최신 코드를 가져와서 **자동으로 병합**
- 로컬 변경사항이 있으면 충돌 가능
- 일반적으로 사용하는 방법

### Fetch
- 최신 정보만 가져옵니다 (병합하지 않음)
- 안전하게 확인 후 병합하고 싶을 때 사용
```powershell
git fetch origin
git diff main origin/main  # 차이점 확인
git merge origin/main       # 수동으로 병합
```

## 작업 흐름 예시

### 일반적인 작업 흐름

```
1. git_빠른가져오기.bat 실행  (최신 코드 가져오기)
2. 코드 수정
3. git_빠른푸시.bat 실행      (GitHub에 업로드)
```

### 충돌이 발생한 경우

```
1. git_빠른가져오기.bat 실행
2. 충돌 발생 → 파일 수동 수정
3. git add .
4. git commit -m "충돌 해결"
5. git_빠른푸시.bat 실행
```

## 유용한 명령어

### 현재 상태 확인
```powershell
git status          # 현재 상태 확인
git log --oneline   # 커밋 이력 확인
```

### 원격 저장소 확인
```powershell
git remote -v       # 원격 저장소 URL 확인
```

### 차이점 확인
```powershell
git fetch origin
git diff main origin/main  # 로컬과 원격의 차이점 확인
```

## 요약

- **Pull**: GitHub → 로컬 (가져오기)
- **Push**: 로컬 → GitHub (업로드)
- **일반 사용**: `git_빠른가져오기.bat` 실행하면 끝!
