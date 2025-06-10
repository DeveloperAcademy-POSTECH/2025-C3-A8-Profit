//
//  SalesInputSheet.swift
//  Soonsu
//
//  Created by coulson on 6/3/25.
//

import SwiftUI
import SwiftData

/// 일별 판매량을 입력/수정하기 위한 시트 화면
struct SalesInputSheet: View {
    @ObservedObject var vm: ProfitViewModel
    //    @Environment(\.dismiss) var dismiss
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var context
    
    @State var items: [SoldItem]
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.menuMaster) { menu in
                    
                    MenuRow(menu: menu,
                            items: $items,
                            vm: vm
                    )
                }
            }
            
            .listStyle(.plain)
            .navigationTitle(vm.sheetTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
        }
    }
    
    
    // MARK: - Toolbar
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("닫기") { dismiss() }
        }
        ToolbarItem(placement: .confirmationAction) {
            Button("등록") {
                vm.updateSales(for: vm.selectedDate, soldItems: items)
                vm.persistSalesData(context)          // SwiftData 저장
                dismiss()
            }
        }
    }
}

// MARK: - 개별 메뉴 Row 컴포넌트
private struct MenuRow: View {
    let menu: MenuItem
    
    @Binding var items: [SoldItem]
    @ObservedObject var vm: ProfitViewModel
    
    @Environment(\.modelContext) private var context
    
    @FocusState private var isFocused: Bool
    
    // MARK: 썸네일 로딩
    private func thumbnail() -> UIImage? {
        if let ui = UIImage(named: menu.image), !menu.image.isEmpty { return ui }
        let predicate = #Predicate<Ingredient> { $0.menuName == menu.name && $0.imageData != nil }
        if let first = try? context.fetch(FetchDescriptor(predicate: predicate)).first,
           let data = first.imageData,
           let ui   = UIImage(data: data) { return ui }
        if let url = URL(string: menu.image),
           let data = try? Data(contentsOf: url),
           let ui   = UIImage(data: data) { return ui }
        return nil
    }
    
    // MARK: 수량 헬퍼
    private func qty() -> Int {
        items.first(where: { $0.id == menu.id })?.qty ?? 0
    }
    private func setQty(_ q: Int) {
        if let idx = items.firstIndex(where: { $0.id == menu.id }) {
            //            q == 0 ? items.remove(at: idx) : (items[idx].qty = q)
            if q == 0 {
                items.remove(at: idx)          // 제거
            } else {
                items[idx].qty = q             // 수정
            }
        } else if q > 0 {
            items.append(SoldItem(id: menu.id, name: menu.name, price: menu.price, qty: q, image: ""))
        }
    }
    
    // MARK: View
    var body: some View {
        HStack(spacing: 14) {
            // 썸네일
            if let img = thumbnail() {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray5))
                    .frame(width: 44, height: 44)
                    .overlay(Text("❓❓❓").font(.caption).foregroundColor(.gray))
            }
            
            // 메뉴 정보
            VStack(alignment: .leading, spacing: 2) {
                Text(menu.name).font(.headline)
                Text("단가 \(menu.price.formatted())원")
                    .font(.caption).foregroundColor(.gray)
                Text("원가 \(menu.materialCostPerUnit.formatted())원")
                    .font(.caption).foregroundColor(.gray)
            }
            Spacer()
            
            // 수량 스테퍼
            HStack(spacing: 0) {
                Button { setQty(max(qty() - 1, 0)) } label: {
                    Image(systemName: "minus.circle.fill")
                        .resizable().frame(width: 28, height: 28)
                        .foregroundColor(.gray)
                }.buttonStyle(.plain)
                
                TextField("", value: Binding(
                    get: { qty() },
                    set: { setQty($0) }
                ), formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .frame(width: 45)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.center)
                .font(.title3)
                .focused($isFocused)
                
                Button { setQty(qty() + 1) } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable().frame(width: 28, height: 28)
                        .foregroundColor(.blue)
                }.buttonStyle(.plain)
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - ProfitViewModel 헬퍼 타이틀
private extension ProfitViewModel {
    var sheetTitle: String {
        let weekday = weekdayKorean(selectedDate)
        return "\(selectedDate.formatted(.dateTime.month().day())) \(weekday)요일 판매량 수정"
    }
}
