# 🌿 Anno Domini Project Archive

본 저장소는 **'Anno Domini' 창업 개발 준비팀**에서 수행했던 Flutter 기반의 크로스 플랫폼 앱 개발 및 관련 프로젝트 코드들을 정리한 아카이브입니다.  
수기로 진행되던 전문가의 워크플로우를 디지털로 전환(ABA-Analysis)하거나, 초기 비즈니스 모델(LifeTree, Bibler)을 기술적으로 구현해 본 도전의 기록입니다.

---

## 🏛 Project Structure & Modules

각 프로젝트는 독립적인 목표를 가지고 개발되었으며, `git subtree`를 통해 체계적으로 통합되었습니다.

### 1. 🔍 Specialist Solutions (ABA Series)
전문 기관의 업무 효율화를 목표로 진행된 프로젝트군입니다.
* **[`/aba-analysis`](./aba-analysis)**: ABA 행동발달연구소를 위한 행동 기록 디지털화 앱 (Online Ver.)
* **[`/aba-analysis-local`](./aba-analysis-local)**: 오프라인 환경을 고려한 로컬 데이터 관리 버전

### 2. 💡 Service Incubation (Core & MVP)
창업 준비 단계에서 시도된 서비스 아이디어 구현 및 테스트 코드들입니다.
* **[`/lifetree`](./lifetree)**: LifeTree 프로젝트 기반 코드 (Anno-domini-project)
* **[`/bibler`](./bibler)**: 성경 기반 서비스 'Bibler' 프로젝트 (Bibler-Project)
* **[`/show-me-the-graph`](./show-me-the-graph)**: ABA-Analysis에 활용될 데이터 시각화 전용 그래프 컴포넌트 개발 (show-me-the-graph)
* **[`/lab-testing`](./lab-testing)**: 각종 기능 실습 및 단위 테스트 코드 모음 (anno-domini)

---

## 🛠 Technical Challenges & Experience

이 프로젝트들을 통해 다음과 같은 기술적 역량을 확보하였습니다.

- **Cross-Platform Development**: `Flutter`와 `Dart`를 활용한 웹/앱 동시 대응
- **Data Digitization**: 아날로그 데이터(수기 기록)를 체계적인 `JSON` 및 `Database` 구조로 설계 및 `Firebase` 활용
- **Data Visualization**: `Canvas` 또는 라이브러리를 활용하여 행동 분석 결과를 시각화(Graphing)
- **Problem Solving**: 미완성 프로젝트를 포함하여 기술적 한계와 비즈니스 요구사항 사이의 조율 경험

---

## 📈 Learning Evolution
이 아카이브에는 초기의 단순 기능 구현(Lab)부터, 외부 기관(ABA 행동발연구소)의 요구사항을 반영한 실무형 솔루션까지의 단계별 성장 과정이 담겨 있습니다.

---
© 2021-2022 **Arenslien**. All rights reserved.
