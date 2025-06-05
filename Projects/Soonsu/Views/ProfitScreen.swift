import SwiftUI
import Combine

struct ProfitScreen: View {
    @ObservedObject var viewModel : ProfitViewModel
    @ObservedObject var menuViewModel: MenuViewModel
    @Binding var selectedTab: TabType
    
    @State private var showFixedCostEditor: Bool = false
    @FocusState private var isInputFocused: Bool
    
    // Combine 구독을 위한 저장
    @State private var cancellables: Set<AnyCancellable> = []


    var body: some View {
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
            menuViewModel.$allIngredients
                .receive(on: DispatchQueue.main)
                .sink { ingredients in
                    viewModel.loadMenuMaster(from: ingredients)
                }
                .store(in: &cancellables)
        }
    }
    
    // MARK: - 고정비 입력/요약 섹션을 별도 View로 분리
    @ViewBuilder
    private var fixedCostSection: some View {
        if viewModel.isFixedCostSet {
            VStack(spacing: 0) {
                Button(action: {
                    withAnimation {
                        showFixedCostEditor.toggle()
                    }
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
                        Image(systemName: showFixedCostEditor ? "chevron.up" : "chevron.down")
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

                if showFixedCostEditor {
                    FixedCostEditor(vm: viewModel)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .focused($isInputFocused)
                }
            }
            .onChange(of: viewModel.isFixedCostSet) { newVal in
                if newVal { showFixedCostEditor = false }
            }
        } else {
            FixedCostEditor(vm: viewModel)
                .focused($isInputFocused)
        }
    }
}
