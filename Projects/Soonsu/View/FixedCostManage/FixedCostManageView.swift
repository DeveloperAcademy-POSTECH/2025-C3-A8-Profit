//
//  FixedCostManageView.swift
//  Soonsu
//
//  Created by JiJooMaeng on 6/4/25.
//

import SwiftUI

enum Tabs: String, CaseIterable {
    case detailTab = "상세 고정비"
    case temporaryTab = "임시 고정비"
}

struct FixedCostManageView: View {
    @ObservedObject var viewModel : ProfitViewModel
    @FocusState private var isInputFocused: Bool
    @State private var selectedTab: Tabs = .detailTab
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                Button {
                    if let tempCost = viewModel.tempMonthlyFixedCost,
                       let tempDays = viewModel.tempOperatingDays {
                        viewModel.monthlyFixedCost = tempCost
                        viewModel.operatingDays = tempDays
                        viewModel.isFixedCostSet = true
                        viewModel.objectWillChange.send()
                        dismiss()
                    }
                } label: {
                    Text("적용")
                }
            }
            
        
    }
}

#Preview {
    NavigationStack {
        FixedCostManageView(viewModel: ProfitViewModel())
    }
}
