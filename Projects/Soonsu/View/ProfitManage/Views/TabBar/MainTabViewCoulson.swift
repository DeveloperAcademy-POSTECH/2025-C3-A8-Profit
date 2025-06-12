//
//  MainTabView.swift
//  Soonsu
//
//  Created by coulson on 6/3/25.
//

import SwiftUI
import SwiftData
import Lottie

struct MainTabViewCoulson: View {
    
    @EnvironmentObject var tabBarState: TabBarState
    
    @Environment(\.modelContext) private var context
    
    @State private var selectedTab: TabType = .home
    
    @StateObject private var profitVM = ProfitViewModel()
    @StateObject private var menuVM: MenuViewModel
    
    // 최초 1회만 저장된 데이터 로드용 플래그
    @State private var isLoaded = false
    
    @StateObject private var keyboardObserver = KeyboardObserver()
    
    init() {
        _menuVM = StateObject(wrappedValue: MenuViewModel())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 1) 탭 선택에 따라 본문을 바꿔줍니다.
            switch selectedTab {
            case .home:
                // 첫 번째 탭: 홈 화면 (임시로 Text로 처리, 필요 시 별도 뷰를 만들어 주세요)
//                Text("홈 화면")
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .background(Color(.systemBackground))
                LottieView(animation: .named("working"))
                    .looping()
                Text("홈 화면을 구성 중이에요")
                    .font(.caption2)
                    .foregroundStyle(.gray)
                    .padding(.bottom,32)
                
                
            case .menu:
                // 두 번째 탭: 메뉴관리 → MyMenuView
                    MyMenuView(viewModel: menuVM)

            case .profit:
                ProfitScreen(viewModel: profitVM, menuViewModel: menuVM, selectedTab: $selectedTab)
                    .onAppear {
                        profitVM.loadMenuMaster(from: menuVM.allIngredients)
                    }
            }
            
            // 2) 하단 탭 바
//            TabBarViewCoulson(selectedTab: $selectedTab)
            // 탭바는 키보드가 숨겨져 있을 때만 표시
            if !keyboardObserver.isKeyboardVisible && tabBarState.isVisible {
                TabBarViewCoulson(selectedTab: $selectedTab)
            }
        }
        .onAppear {
            tabBarState.isVisible = true
            menuVM.setContextIfNeeded(context)
            
            // ✅ ProfitViewModel의 데이터는 앱 실행 시 1회만 불러오도록
            if !isLoaded {
                profitVM.loadFromStorage(context: context)
                isLoaded = true
            }
        }
    }
}

#Preview {
    // SwiftData in-memory 컨테이너를 연결해서 미리보기도 가능합니다.
    MainTabViewCoulson()
        .modelContainer(for: [Ingredient.self], inMemory: true)
        .environmentObject(TabBarState())
}
