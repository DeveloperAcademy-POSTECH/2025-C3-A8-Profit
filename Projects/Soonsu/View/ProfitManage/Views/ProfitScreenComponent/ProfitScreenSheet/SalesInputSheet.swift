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
                do {
                        try context.save()
                        print("✅ SwiftData 판매 데이터 저장 완료")   // ← 로그로 확인
                    } catch {
                        print("❌ 저장 실패:", error)
                    }
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
    @FocusState private var focusedFieldID: Int?
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
    
    // MARK: - 수량 관련 함수
    private func quantity(for id: Int) -> Int {
        items.first(where: { $0.id == id })?.qty ?? 0
    }
    
    
    private func updateQty(for id: Int, delta: Int) {
        if let idx = items.firstIndex(where: { $0.id == id }) {
            let newQty = max(items[idx].qty + delta, 0)
            if newQty > 0 {
                items[idx].qty = newQty
            } else {
                items.remove(at: idx)
            }
        } else if delta > 0,
                  let menu = vm.menuMaster.first(where: { $0.id == id }) {
            items.append(SoldItem(id: menu.id, name: menu.name, price: menu.price, qty: delta, image: ""))
        }
    }
    
    
    private func updateQtyDirect(for id: Int, to newQty: Int) {
        if newQty <= 0 {
            if let idx = items.firstIndex(where: { $0.id == id }) {
                items.remove(at: idx)
            }
        } else if let idx = items.firstIndex(where: { $0.id == id }) {
            items[idx].qty = newQty
        } else if let menu = vm.menuMaster.first(where: { $0.id == id }) {
            items.append(SoldItem(id: menu.id, name: menu.name, price: menu.price, qty: newQty, image: ""))
        }
    }
    
    // MARK: View
    var body: some View {
        HStack(spacing: 16) {
            // 썸네일
            if let img = thumbnail() {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray5))
                    .frame(width: 64, height: 64)
                    .overlay(Text("❓❓❓").font(.caption).foregroundColor(.gray))
            }
            
            // 메뉴 정보
            VStack(alignment: .leading, spacing: 2) {
                Text(menu.name).font(.headline)
                Text("판매비 \(menu.price.formatted())원")
                    .font(.caption).foregroundColor(.gray)
                Text("재료비 \(menu.materialCostPerUnit.formatted())원")
                    .font(.caption).foregroundColor(.gray)
            }
            Spacer()
            
            // 수량 스테퍼
            HStack(spacing: 0) {
                Button {
                    updateQty(for: menu.id, delta: -1)
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.gray.opacity(0.4))
                }
                .buttonStyle(.plain)
                
                
                // 수량 입력 필드
                TextField("", value: Binding(
                    get: { quantity(for: menu.id) },
                    set: { newVal in updateQtyDirect(for: menu.id, to: newVal) }
                ), formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .frame(minWidth: 40)
                .fixedSize(horizontal: true, vertical: false)
//                .textFieldStyle(.roundedBorder)
                .font(.title3)
                .focused($focusedFieldID, equals: menu.id)
                
                
                Button {
                    updateQty(for: menu.id, delta: 1)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.primaryColor700)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - ProfitViewModel 헬퍼 타이틀
//private extension ProfitViewModel {
//    var sheetTitle: String {
//        let weekday = weekdayKorean(selectedDate)
//        return "\(selectedDate.formatted(.dateTime.month().day())) \(weekday)요일 판매량 수정"
//    }
//}

private extension ProfitViewModel {
    
    var sheetTitle: String {
        let dayString = DateFormatter.korMonthDay.string(from: selectedDate)   // n월 xx일
        let weekday   = weekdayKorean(selectedDate)                            // n요일
        return "\(dayString)(\(weekday)) 판매량 수정"
    }
}
