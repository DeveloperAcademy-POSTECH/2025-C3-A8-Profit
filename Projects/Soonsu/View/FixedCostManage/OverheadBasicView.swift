//
//  OverheadBasicView.swift
//  Soonsu
//
//  Created by JiJooMaeng on 6/8/25.
//

import SwiftUI
import SwiftData

struct OverheadBasicView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    var category: OverheadCategory

    @Binding var tempCosts: [(OverheadCost, BasicCost)]

    @State private var amountString: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("매달 지불하는 \(category.rawValue)를(을) 입력해 주세요.")
                .font(.subheadline)

            VStack(alignment: .leading) {
                Text("월 \(category.rawValue)")
                    .font(.subheadline)
                    .bold()

                HStack {
                    TextField("금액을 입력해 주세요", text: $amountString)
                        .keyboardType(.numberPad)
                        .padding(12)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)

                    Text("원")
                        .font(.subheadline)
                        .padding(.leading, 4)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)

            Spacer()

            Button(action: save) {
                Text("\(category.rawValue) 등록")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 4) {
                    Text(category.rawValue)
                        .font(.headline)
                    Button {
                        // info 버튼 동작
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundStyle(.black)
                    }
                }
            }
        }
    }

    private func save() {
        guard let amount = Int(amountString) else { return }
        let overhead = OverheadCost(category: category)
        let basic = BasicCost(overheadCost: overhead, amount: amount)
        tempCosts.append((overhead, basic))
        dismiss()
    }
}

#Preview {
    NavigationStack {
        OverheadBasicView(category: .rent, tempCosts: .constant([]))
    }
}
