//
//  FixedCostManageView.swift
//  Soonsu
//
//  Created by JiJooMaeng on 6/4/25.
//

import SwiftUI
import SwiftData

enum Tabs: String, CaseIterable {
    case detailTab = "상세 고정비"
    case temporaryTab = "임시 고정비"
}

struct FixedCostManageView: View {
    @ObservedObject var viewModel : ProfitViewModel
    @FocusState private var isInputFocused: Bool
    @State private var selectedTab: Tabs = .detailTab
    @State private var showConfirmationAlert = false
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
            ZStack {
                VStack {
                    Picker("", selection: $selectedTab) {
                        ForEach(Tabs.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .cornerRadius(9)
                    
                    ScrollView {
                        if selectedTab == .detailTab {
                            FixedCostDetailView(vm: viewModel)
                        } else if selectedTab == .temporaryTab {
                            FixedCostTemporaryComponent(vm: viewModel).focused($isInputFocused)
                                .padding(.horizontal, 16)
                        }
                    }
                }
                
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("고정비 관리")
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                    }
                }
            }
            .toolbar {
                Button {
                    print("툴바 버튼 클릭됨")
                    let latest = try? context.fetch(FetchDescriptor<FixedCostTemporary>(sortBy: [SortDescriptor(\FixedCostTemporary.date, order: .reverse)])).first
                    print("가져온 latest: \(String(describing: latest))")

                    if let latest {
                        print("✅ 임시 고정비 값 적용 시작")
                        viewModel.monthlyFixedCost = latest.monthlyFixedCost
                        viewModel.operatingDays = latest.operatingDays
                        viewModel.isFixedCostSet = true
                        viewModel.lastFixedCostUpdate = Date()
                        viewModel.saveMonthlyFixedCost(to: context)
                        print("🟢 적용 완료: \(viewModel.monthlyFixedCost), \(viewModel.operatingDays)")
                        showConfirmationAlert = true
                    } else {
                        print("❌ 최신 임시 고정비 데이터를 찾을 수 없음")
                    }
                } label: {
                    Text("적용")
                }
            }
            .alert("적용 완료", isPresented: $showConfirmationAlert) {
                Button("확인") {
                    dismiss()
                }
            } message: {
                Text(
                        selectedTab == .detailTab
                        ? "상세 고정비 설정이 순이익 계산에 적용되었습니다."
                        : "임시 고정비 설정이 순이익 계산에 적용되었습니다."
                    )
            }
            
        
    }
}

#Preview {
    NavigationStack {
        FixedCostManageView(viewModel: ProfitViewModel())
    }
}
