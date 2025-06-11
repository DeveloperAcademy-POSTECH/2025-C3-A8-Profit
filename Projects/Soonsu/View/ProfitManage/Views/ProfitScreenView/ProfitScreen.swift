import SwiftUI
import Combine
import SwiftData

struct ProfitScreen: View {
    @ObservedObject var viewModel : ProfitViewModel
    @ObservedObject var menuViewModel: MenuViewModel
    @Binding var selectedTab: TabType
    @Environment(\.modelContext) private var context
    @EnvironmentObject var tabBarState: TabBarState
    
    @State private var showFixedCostEditor: Bool = false
    @FocusState private var isInputFocused: Bool
    
    // Combine 구독을 위한 저장
    @State private var cancellables: Set<AnyCancellable> = []
    
    
    ///인건비/간접비/감가상각비 탭 또는 뷰로 이동 대비
    @State private var navigateToNextView = false
    
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    CalendarGridView(vm: viewModel)
                        .padding(.top, 12)
                    
                    fixedCostSection
                    
                    DailyProfitSummary(vm: viewModel)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 48)
            }
            .onTapGesture {
                isInputFocused = false
            }
            .background(Color(.systemGray6).ignoresSafeArea())
            .sheet(isPresented: $viewModel.showSalesInputSheet) {
                let items = viewModel.salesData(for: viewModel.selectedDate)?.items
                ?? viewModel.menuMaster.map {
                    SoldItem(id: $0.id, name: $0.name, price: $0.price, qty: 0, image: "")
                }
                SalesInputSheet(vm: viewModel, items: items)
            }
            .onAppear {
                tabBarState.isVisible = true

                menuViewModel.$allIngredients
                    .receive(on: DispatchQueue.main)
                    .sink { ingredients in
                        viewModel.loadMenuMaster(from: ingredients)
                    }
                    .store(in: &cancellables)

                // ✅ 앱 시작 시 현재 월 고정비도 불러오기
                viewModel.loadMonthlyFixedCost(from: context)
            }
            
            
            //0607 add
            .onChange(of: viewModel.currentMonth) { _ in
                viewModel.loadMonthlyFixedCost(from: context)
            }
            
            
            .navigationDestination(isPresented: $navigateToNextView) {
                FixedCostManageView(viewModel: viewModel)
            }
        }
//        .onAppear {
//            // 🔹 최초 진입 시 SwiftData → 메모리로 로드
//            viewModel.loadPersistedSales(context)
//        }
        .task {
//            await viewModel.loadPersistedSales(context)
            viewModel.loadPersistedSales(context)
        }
    }
    
    // MARK: - 고정비 입력/요약 섹션을 별도 View로 분리
    @ViewBuilder
    private var fixedCostSection: some View {
        if viewModel.isFixedCostSet {
            VStack(spacing: 0) {
                Button(action: {
                    navigateToNextView = true
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("총 고정비")
                            Text("영업일수")
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(viewModel.monthlyFixedCost.formatted(.number.grouping(.automatic)) + " 원")
                                .fontWeight(.semibold)
                            Text("\(viewModel.operatingDays)일")
                                .fontWeight(.semibold)
                        }
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.03), radius: 2, x: 0, y: 1)
                    )
                    .foregroundColor(.primary)
                }
                .buttonStyle(.plain)
            }
        } else {
            FixedCostEditor(vm: viewModel).focused($isInputFocused)
        }
    }
}


//#Preview {
//    let profitVM = ProfitViewModel()
//    let menuVM = MenuViewModel()
//
//    // 날짜 포맷 함수 (format private 대체)
//    func format(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        return formatter.string(from: date)
//    }
//
//    let today = Date()
//
//    // 샘플 menuMaster
//    profitVM.menuMaster = [
//        MenuItem(id: 1, name: "돈까스", price: 8000, materialCostPerUnit: 2500, image: ""),
//        MenuItem(id: 2, name: "우동", price: 6000, materialCostPerUnit: 1800, image: "")
//    ]
//
//    // 샘플 매출
//    profitVM.dailySalesData[format(today)] = DailySales(
//        revenue: 20000,
//        materialCost: 5500,
//        items: [
//            SoldItem(id: 1, name: "돈까스", price: 8000, qty: 2, image: ""),
//            SoldItem(id: 2, name: "우동", price: 6000, qty: 1, image: "")
//        ]
//    )
//
//    // 기본 고정비 설정
//    profitVM.monthlyFixedCost = 3000000
//    profitVM.operatingDays = 30
//    profitVM.isFixedCostSet = true
//
//    // selectedTab을 위한 @State
//    @State var tab: TabType = .profit
//
//    // showFixedCostManage for TabBar visibility
//    @State var showFixedCostManage = false
//
//    return ProfitScreen(
//        viewModel: profitVM,
//        menuViewModel: menuVM,
//        selectedTab: .constant(tab),
//        showFixedCostManage: $showFixedCostManage
//    )
//}
