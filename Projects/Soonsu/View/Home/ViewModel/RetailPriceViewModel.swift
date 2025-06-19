

//
//  RetailPriceViewModel.swift
//  Soonsu
//
//  Created by coulson on 6/19/25.
//

import Foundation

class RetailPriceViewModel: ObservableObject {
    struct PriceItem: Identifiable {
        var id: String { name }
        let name: String
        let price: Int
        let unit: String
    }

    @Published var prices: [PriceItem] = []
    private let apiKey = "0cffd6b9-bd44-4903-9024-022c229c6ec9"

    func fetchPrices(for foods: [String]) {
        let urlStr = "https://www.kamis.or.kr/service/price/xml.do?action=dailyPriceByCategoryList&key=\(apiKey)&categoryCode=100&returnType=json"

        guard let url = URL(string: urlStr) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print("❌ No data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let decoded = try JSONDecoder().decode(KamisResponse.self, from: data)
                DispatchQueue.main.async {
                    self.prices = decoded.data.item
                        .filter { foods.contains($0.item_name) }
                        .map { PriceItem(name: $0.item_name, price: $0.priceInt ?? 0, unit: "1kg") }
                }
            } catch {
                print("❌ Decoding error: \(error)")
            }
        }.resume()
    }
}

struct KamisResponse: Codable {
    let data: KamisData
}

struct KamisData: Codable {
    let item: [KamisRetailPrice]
}

struct KamisRetailPrice: Codable {
    let item_name: String
    let dpr1: String

    var priceInt: Int? {
        Int(dpr1.replacingOccurrences(of: ",", with: ""))
    }
}
