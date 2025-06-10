//
//  IngredientListView.swift
//  Soonsu
//
//  Created by coulson on 6/9/25.
//

import SwiftUI

struct IngredientListView: View {
    let ingredients: [IngredientInfo]
//    let isNew: Bool
//    let onAddTapped: () -> Void
    
    var body: some View {
        List {
            ForEach(ingredients) { ing in
                HStack {
                    Image(uiImage: UIImage(named: ing.name) ?? UIImage(named: "포항초")!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 24, height: 24)
                    
                    Text(ing.name)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(ing.amount)
                        .font(.subheadline)
                        .frame(width: 60, alignment: .trailing)
                    
                    Text("\(ing.unitPrice.formatted())원")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .frame(width: 70, alignment: .trailing)
                    Image(systemName: "pencil")
                        .font(.body)
                        .foregroundColor(.blue)
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
}
