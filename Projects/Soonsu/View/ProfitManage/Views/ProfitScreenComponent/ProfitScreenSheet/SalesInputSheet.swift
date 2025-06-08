//
//  SalesInputSheet.swift
//  Soonsu
//
//  Created by coulson on 6/3/25.
//

import SwiftUI

/// 일별 판매량을 입력/수정하기 위한 시트 화면
struct SalesInputSheet: View {
    @ObservedObject var vm: ProfitViewModel
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.modelContext) private var context

    @State var items: [SoldItem]
    
    @FocusState private var focusedFieldID: Int?
    
    
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
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.menuMaster) { menu in
                    HStack(spacing: 14) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray5))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Text("❓❓❓")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            )
                        
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(menu.name)
                                .font(.headline)
                            Text("단가: \(menu.price.formatted(.number.grouping(.automatic))) 원")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("원가: \(menu.materialCostPerUnit.formatted(.number.grouping(.automatic))) 원")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        
                        Spacer()
                        
                        
                        HStack(spacing: 0) {
                            Button {
                                updateQty(for: menu.id, delta: -1)
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.gray)
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
                            .textFieldStyle(.roundedBorder)
                            .font(.title3)
                            .focused($focusedFieldID, equals: menu.id)
                            
                            
                            Button {
                                updateQty(for: menu.id, delta: 1)
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(.plain)
                        }
                        Button(action: {
                            // 설명 생성 기능(추후 AI 연동)
                        }) {
                            HStack(alignment: .top, spacing: 2) {
                                Text("✨")
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("설명")
                                    Text("생성")
                                }
                            }
                            .font(.caption)
                            .foregroundColor(.primary)
                            .padding(6)
                            .background(Color.purple.opacity(0.15))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            .listStyle(.plain)
            .navigationTitle("\(vm.selectedDate.formatted(.dateTime.month().day())) \(vm.weekdayKorean(vm.selectedDate))요일 판매량 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("닫기") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("등록") {
                        vm.updateSales(for: vm.selectedDate, soldItems: items)
                        
                        // ✅ SwiftData에 판매 데이터 저장
                        vm.persistSalesData(context)
                        
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("완료") {
                        focusedFieldID = nil // 키보드 숨기기
                    }
                }
            }
        }
    }
}


//#Preview {
//    // 뷰모델과 초기 items 배열 준비
//    let previewVM = ProfitViewModel()
//    let initialItems = previewVM.menuMaster.map {
//        SoldItem(id: $0.id, name: $0.name, price: $0.price, qty: 1, image: "")
//    }
//    SalesInputSheet(vm: previewVM, items: initialItems)
//        .previewLayout(.sizeThatFits)
//}
