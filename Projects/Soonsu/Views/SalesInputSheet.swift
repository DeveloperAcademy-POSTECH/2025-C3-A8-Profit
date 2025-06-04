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
    @State var items: [SoldItem]

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
                        VStack(alignment: .leading) {
                            Text(menu.name)
                                .font(.headline)
                            Text("단가: \(menu.price.formatted(.number.grouping(.automatic))) 원")
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
                            Text("\(quantity(for: menu.id))")
                                .frame(width: 32)
                                .font(.title3)
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
                        Button {
                            // 설명 생성 기능(추후 AI 연동)
                        } label: {
                            Text("✨ 설명 생성")
                                .font(.caption)
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
                        dismiss()
                    }
                }
            }
        }
    }
}


#Preview {
    // 뷰모델과 초기 items 배열 준비
    let previewVM = ProfitViewModel()
    let initialItems = previewVM.menuMaster.map {
        SoldItem(id: $0.id, name: $0.name, price: $0.price, qty: 1, image: "")
    }
    SalesInputSheet(vm: previewVM, items: initialItems)
        .previewLayout(.sizeThatFits)
}
