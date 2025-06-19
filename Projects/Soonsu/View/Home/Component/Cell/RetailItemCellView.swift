//
//  RetailItemCellView.swift
//  Soonsu
//
//  Created by coulson on 6/19/25.
//

import SwiftUI

struct RetailItemCellView: View {
    let name: String
    let price: Int
    var body: some View {
        VStack {
            Image(name) // 아이콘이나 이미지
            Text(name)
            Text("\(price.formatted())원")
        }
        .padding()
        .background(.white)
        .cornerRadius(8)
//        .shadow(...)
    }
}
