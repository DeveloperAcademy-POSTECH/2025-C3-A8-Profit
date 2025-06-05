# 🚀 순수한 OO

![배너 이미지 또는 로고](링크)

> 간단한 한 줄 소개 – 프로젝트의 핵심 가치 또는 기능

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)]()
[![Xcode](https://img.shields.io/badge/Xcode-16.4-blue.svg)]()
[![License](https://img.shields.io/badge/license-MIT-green.svg)]()

---
----
## 🗂 목차
- [소개](#소개)
- [프로젝트 기간](#프로젝트-기간)
- [기술 스택](#기술-스택)
- [기능](#기능)
- [시연](#시연)
- [폴더 구조](#폴더-구조)
- [팀 소개](#팀-소개)
- [Git 컨벤션](#git-컨벤션)
- [테스트 방법](#테스트-방법)
- [프로젝트 문서](#프로젝트-문서)
- [라이선스](#lock_with_ink_pen-license)

---

## 📱 소개

> 요식업 사장님 A에게 메뉴사진 한 장으로 재료원가를 알려주고 순수익을 계산해준다.

[🔗 앱스토어/웹 링크](https://example.com)


## 📆 프로젝트 기간
- 전체 기간: `2025.05.26 - 2025.06.08`
- 개발 기간: `2025.05.27 - 2025.06.08`


## 🛠 기술 스택

- Swift / SwiftUI / Firebase(FirebaseAI, FirebaseCore) / Gemini API
- 아키텍처: MVVM / MVC / Clean Architecture 등
- 기타 도구: Figma / GitHub Projects


## 🌟 주요 기능

- ✅ 메뉴관리
- ✅ 기능 2
- ✅ 기능 3

> 필요시 이미지, GIF, 혹은 링크 삽입


## 🖼 화면 구성 및 시연

| 기능 | 설명 | 이미지 |
|------|------|--------|
| 예시1 | 기능 요약 | ![gif](링크) |
| 예시2 | 기능 요약 | ![gif](링크) |


## 🧱 폴더 구조

```
.
├── Projects
│   ├── Assets.xcassets
│   │   ├── AccentColor.colorset
│   │   │   └── Contents.json
│   │   ├── AppIcon.appiconset
│   │   │   └── Contents.json
│   │   └── Contents.json
│   ├── File.txt
│   ├── GoogleService-Info.plist
│   ├── Soonsu
│   │   ├── Component
│   │   │   ├── SSCircularProgressComponent.swift
│   │   │   ├── SSCostRateProgressComponent.swift
│   │   │   └── SSMenuRowComponent.swift
│   │   ├── Models
│   │   │   ├── DailySales.swift
│   │   │   ├── IngredientEntity.swift
│   │   │   ├── IngredientInfo.swift
│   │   │   ├── MenuItem.swift
│   │   │   └── SoldItem.swift
│   │   ├── Utilities
│   │   │   └── DateFormatters.swift
│   │   ├── ViewModels
│   │   │   ├── MenuViewModel.swift
│   │   │   └── ProfitViewModel.swift
│   │   └── Views
│   │       ├── CalendarGridView.swift
│   │       ├── DailyProfitSummary.swift
│   │       ├── FixedCostBox.swift
│   │       ├── IngredientScreens
│   │       │   ├── IngredientAddView.swift
│   │       │   ├── IngredientHeaderView.swift
│   │       │   ├── IngredientListView.swift
│   │       │   ├── IngredientResultFooterView.swift
│   │       │   ├── IngredientResultView.swift
│   │       │   ├── MenuInputView.swift
│   │       │   ├── MenuRowView.swift
│   │       │   └── MyMenuView.swift
│   │       ├── MainTabView.swift
│   │       ├── MyNameView.swift
│   │       ├── ProfitScreen.swift
│   │       ├── SalesInputSheet.swift
│   │       └── TabBarView.swift
│   ├── Soonsu.xcodeproj
│   │   ├── project.pbxproj
│   │   ├── project.xcworkspace
│   │   │   ├── contents.xcworkspacedata
│   │   │   ├── xcshareddata
│   │   │   │   └── swiftpm
│   │   │   │       ├── configuration
│   │   │   │       └── Package.resolved
│   │   │   └── xcuserdata
│   │   │       └── coulson.xcuserdatad
│   │   │           └── UserInterfaceState.xcuserstate
│   │   └── xcuserdata
│   │       └── coulson.xcuserdatad
│   │           └── xcschemes
│   │               └── xcschememanagement.plist
│   ├── SoonsuApp.swift
│   ├── SoonsuTests
│   │   └── SoonsuTests.swift
│   └── SoonsuUITests
│       ├── SoonsuUITests.swift
│       └── SoonsuUITestsLaunchTests.swift
└── README.md

```


## 🧑‍💻 팀 소개

| 이름 | 역할 | GitHub |
|------|------|--------|
| 홍길동 | iOS Developer | [@hong](https://github.com/hong) |
| 김개발 | PM | [@devkim](https://github.com/devkim) |

[🔗 팀 블로그 / 미디엄 링크](https://medium.com/example)

## 🔖 브랜치 전략
`(예시)`
- `main`: 배포 가능한 안정 버전
- `develop`: 통합 개발 브랜치
- `feature/*`: 기능 개발 브랜치
- `bugfix/*`: 버그 수정 브랜치
- `hotfix/*`: 긴급 수정 브랜치

## 🌀 커밋 메시지 컨벤션
`(예시)`  
[Gitmoji](https://gitmoji.dev) + [Conventional Commits](https://www.conventionalcommits.org)

### 예시
- ✨ feat: 로그인 화면 추가
- 🐛 fix: 홈 진입 시 크래시 수정
- ♻️ refactor: 데이터 모델 구조 정리


## ✅ 테스트 방법

1. 이 저장소를 클론합니다.
```bash
git clone https://github.com/yourteam/project.git
```
2. `Xcode`로 `.xcodeproj` 또는 `.xcworkspace` 열기
3. 시뮬레이터 환경 설정: iPhone 15 / iOS 17
4. `Cmd + R`로 실행 / `Cmd + U`로 테스트 실행


## 📎 프로젝트 문서

- [기획 히스토리](링크)
- [디자인 히스토리](링크)
- [기술 문서 (아키텍처 등)](링크)


## 📝 License

This project is licensed under the ~~[CHOOSE A LICENSE](https://choosealicense.com). and update this line~~
