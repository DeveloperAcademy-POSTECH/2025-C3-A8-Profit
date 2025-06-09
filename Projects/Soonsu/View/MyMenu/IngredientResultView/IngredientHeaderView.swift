//
//  IngredientHeaderView.swift
//  Soonsu
//
//  Created by coulson on 6/9/25.
//
import SwiftUI

struct IngredientHeaderView: View {
    let menuName: String
    let menuPrice: String
    let image: UIImage?
    
    var body: some View {
        
        HStack(spacing: 16) {
            if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
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
                    .font(.title3).bold()
                Text("\(menuPrice)원")
                    .font(.title3).bold()
                    .foregroundStyle(.blue)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top)
        .padding(.bottom,4)
        
    }
}
