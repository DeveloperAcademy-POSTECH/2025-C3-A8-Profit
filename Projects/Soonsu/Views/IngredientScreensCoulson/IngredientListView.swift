//
//  IngredientListView.swift
//  Soonsu
//
//  Created by coulson on 6/3/25.
//

import SwiftUI

struct IngredientListView: View {
    let ingredients: [IngredientInfoCoulson]
    let isNew: Bool
    let onAddTapped: () -> Void

    var body: some View {
        List {
            ForEach(ingredients) { ing in
                HStack {
                    Text(String(ing.name.first ?? "🥘"))
                        .font(.system(size: 24))
                    Text(ing.name)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(ing.amount)
                        .font(.subheadline)
                        .frame(width: 60, alignment: .trailing)
                    Text("\(ing.unitPrice.formatted())원")
                        .font(.subheadline)
                        .frame(width: 70, alignment: .trailing)
                    Image(systemName: "chevron.up")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .listRowSeparator(.hidden)
            }
            
            if isNew {
                Button {
                    onAddTapped()
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("재료 추가하기")
                    }
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    IngredientListView(
        ingredients: [
            IngredientInfoCoulson(name: "당근", amount: "100g", unitPrice: 500),
            IngredientInfoCoulson(name: "감자", amount: "200g", unitPrice: 800),
            IngredientInfoCoulson(name: "양파", amount: "50g", unitPrice: 300)
        ],
        isNew: true,
        onAddTapped: { print("추가 버튼 눌림") }
    )
    .modelContainer(for: [IngredientCoulson.self], inMemory: true)
}
