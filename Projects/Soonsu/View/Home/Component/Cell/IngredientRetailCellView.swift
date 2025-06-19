//
//  IngredientRetailCellView.swift
//  Soonsu
//
//  Created by coulson on 6/19/25.
//

import SwiftUI

struct IngredientRetailCellView: View {
    let item: RetailPriceViewModel.PriceItem

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: "leaf.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 24)
                .foregroundColor(.green)

            Text(item.name)
                .font(.footnote)
                .fontWeight(.semibold)

            Text("\(item.price.formatted())원 / \(item.unit)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
    }
}
