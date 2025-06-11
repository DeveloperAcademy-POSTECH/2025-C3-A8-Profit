//
//  MainTabView.swift
//  Soonsu
//
//  Created by coulson on 6/3/25.
//

import SwiftUI
import SwiftData

struct MainTabViewCoulson: View {
    
    @Environment(\.modelContext) private var context
    
    @State private var selectedTab: TabType = .home
    
    //    @Query(sort: \IngredientEntity.createdAt, order: .reverse)
    //    private var allIngredients: [IngredientEntity]
    
    //    @StateObject private var menuVM = MenuViewModel()
    @StateObject private var profitVM = ProfitViewModel()
//    @StateObject private var menuVM = MenuViewModel.empty
    @StateObject private var menuVM: MenuViewModel
    
    // 최초 1회만 저장된 데이터 로드용 플래그
    @State private var isLoaded = false
    
    init() {
        _menuVM = StateObject(wrappedValue: MenuViewModel())
    }
    
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
//                NavigationStack {
                    MyMenuView(viewModel: menuVM)
//                }
//                
            case .profit:
                ProfitScreen(viewModel: profitVM, menuViewModel: menuVM, selectedTab: $selectedTab)
                    .onAppear {
                        profitVM.loadMenuMaster(from: menuVM.allIngredients)
                    }
//            case .cost:
//                // 네 번째 탭: 비용관리 (임시로 Text로 처리)
//                Text("비용관리 화면")
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .background(Color(.systemBackground))
            }
            
            // 2) 하단 탭 바
            TabBarViewCoulson(selectedTab: $selectedTab)
        }
        .onAppear {
            menuVM.setContextIfNeeded(context)
            
            // ✅ ProfitViewModel의 데이터는 앱 실행 시 1회만 불러오도록
            if !isLoaded {
                profitVM.loadFromStorage(context: context)
                isLoaded = true
            }
        }
        //        .onAppear {
        //            profitVM.loadMenuMaster(from: allIngredients)
        //        }
        // 이 부분에서 SwiftData의 modelContainer를 전달해야 MyMenuView가 정상 동작합니다.
            
            //
        //        .modelContainer(for: [Ingredient.self])
        .modelContainer(for: [
            Ingredient.self,
            SoldItemModel.self,
            DailySalesRecord.self,
            MonthlyFixedCostRecord.self
        ])
    }
}

#Preview {
    // SwiftData in-memory 컨테이너를 연결해서 미리보기도 가능합니다.
    MainTabViewCoulson()
        .modelContainer(for: [Ingredient.self], inMemory: true)
}
