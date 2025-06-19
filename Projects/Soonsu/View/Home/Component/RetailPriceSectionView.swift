//
//  RetailPriceSectionView.swift
//  Soonsu
//
//  Created by coulson on 6/19/25.
//
import SwiftUI

struct RetailPriceSectionView: View {
    @StateObject private var vm = RetailPriceViewModel() // API 호출 담당
    let items: [String] = ["대파", "양파", "당근"]
    var body: some View {
        VStack(alignment: .leading) {
            Text("식자재 소매가").font(.headline)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(vm.prices, id: \.name) { item in
                        RetailItemCellView(name: item.name, price: item.price)
                    }
                }
            }
        }
        .onAppear { vm.fetchPrices(for: items) }
    }
}

/*
struct RetailPriceSectionView: View {
    @StateObject private var viewModel = RetailPriceViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("식자재 소매가")
                    .font(.headline)
                Spacer()
                Text("단위: 원 (\(viewModel.today))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                ForEach(viewModel.ingredients, id: \.name) { item in
                    IngredientRetailCellView(item: item)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5)
        .onAppear {
            viewModel.fetchRetailPrices()
        }
    }
}
*/
