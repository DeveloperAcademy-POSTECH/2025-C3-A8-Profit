//
//  IngredientHeaderView.swift
//  Soonsu
//
//  Created by coulson on 6/3/25.
//

import SwiftUI

struct IngredientHeaderView: View {
    let menuName: String
    let menuPrice: String
    let image: UIImage?
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 64, height: 64)
                    .overlay(
                        Image(systemName: "fork.knife.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .padding(12)
                            .foregroundColor(.orange)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(menuName)
                    .font(.headline)
                Text("\(menuPrice)원")
                    .font(.title3).bold()
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top)
    }
}

#Preview {
    IngredientHeaderView(
        menuName: "된장찌개",
        menuPrice: "9000",
        image: nil
    )
    .previewLayout(.sizeThatFits)
}
