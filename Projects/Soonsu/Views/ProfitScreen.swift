//
//  ProfitScreen.swift
//  Soonsu
//
//  Created by coulson on 6/3/25.
//

import SwiftUI

/// ‘수익관리’ 탭 전체 화면 (달력, 고정비, 일별 요약)
struct ProfitScreen: View {
    @StateObject var vm = ProfitViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                CalendarGridView(vm: vm)
                    .padding(.top, 12)
                FixedCostBox(vm: vm)
                DailyProfitSummary(vm: vm)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 48)
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .sheet(isPresented: $vm.showSalesInputSheet) {
            let initialItems = vm.salesData(for: vm.selectedDate)?.items
                ?? vm.menuMaster.map { SoldItem(id: $0.id, name: $0.name, price: $0.price, qty: 0, image: "") }
            SalesInputSheet(vm: vm, items: initialItems)
        }
    }
}

#Preview {
    ProfitScreen()
        .modelContainer(for: [IngredientEntity.self], inMemory: true)
}
