//
//  MainTabView.swift
//  Soonsu
//
//  Created by coulson on 6/3/25.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @State private var selectedTab: TabType = .home

    var body: some View {
        VStack(spacing: 0) {
            // 1) 탭 선택에 따라 본문을 바꿔줍니다.
            switch selectedTab {
            case .home:
                // 첫 번째 탭: 홈 화면 (임시로 Text로 처리, 필요 시 별도 뷰를 만들어 주세요)
                Text("홈 화면")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
                
            case .menu:
                // 두 번째 탭: 메뉴관리 → MyMenuView
                NavigationStack {
                    MyMenuView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .profit:
                // 세 번째 탭: 수익관리 → ProfitScreen
                ProfitScreen()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .cost:
                // 네 번째 탭: 비용관리 (임시로 Text로 처리)
                Text("비용관리 화면")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
            }

            // 2) 하단 탭 바
            TabBarView(selectedTab: $selectedTab)
        }
        // 이 부분에서 SwiftData의 modelContainer를 전달해야 MyMenuView가 정상 동작합니다.
        .modelContainer(for: [IngredientEntity.self])
    }
}

#Preview {
    // SwiftData in-memory 컨테이너를 연결해서 미리보기도 가능합니다.
    MainTabView()
        .modelContainer(for: [IngredientEntity.self], inMemory: true)
}
