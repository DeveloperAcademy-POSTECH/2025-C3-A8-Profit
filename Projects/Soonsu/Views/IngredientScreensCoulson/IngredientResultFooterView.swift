//
//  IngredientResultFooterView.swift
//  Soonsu
//
//  Created by coulson on 6/3/25.
//

import SwiftUI

struct IngredientResultFooterView: View {
    let totalCost: Int
    let isNew: Bool
    let onPrimaryTapped: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("재료원가는 \(totalCost.formatted())원입니다")
                .font(.subheadline)

            Button(isNew ? "메뉴 등록" : "확인") {
                onPrimaryTapped()
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(isNew ? Color.blue : Color.gray.opacity(0.3))
            .foregroundColor(isNew ? .white : .black)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
        .background(
            Color(UIColor.systemBackground)
                .shadow(color: .black.opacity(0.1), radius: 5, y: -2)
        )
    }
}

#Preview {
    Group {
        IngredientResultFooterView(
            totalCost: 1600,
            isNew: true,
            onPrimaryTapped: { print("신규 메뉴 등록") }
        )
        .previewLayout(.sizeThatFits)
        .padding()

        IngredientResultFooterView(
            totalCost: 1600,
            isNew: false,
            onPrimaryTapped: { print("확인 버튼 눌림") }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
