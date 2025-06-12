//
//  IngredientResultFooterView.swift
//  Soonsu
//
//  Created by coulson on 6/9/25.
//

import SwiftUI

struct IngredientResultFooterView: View {
    let totalCost: Int
    let isNew: Bool
    let onPrimaryTapped: () -> Void
    let onAddTapped: () -> Void
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            Button {
                onAddTapped()
            } label: {
                HStack(spacing: 0) {
                    Image(systemName: "plus.circle.fill")
                        .padding(.trailing, 4)
//                        .foregroundStyle(Color.primaryColor700)
                        .foregroundStyle(.blue)
                    Text("재료 추가하기")
                        .foregroundStyle(.blue)
//                        .foregroundStyle(Color.primaryColor700)
                }
            }
            
            
            HStack(spacing:0) {
                Group {
                    Text("재료원가는")
                        .foregroundStyle(.gray)
                    Text(totalCost.formatted())
                        .foregroundStyle(.blue)
                    Text("원입니다")
                        .foregroundStyle(.gray)
                }
                .font(.title3)
                .fontWeight(.bold)
            }
            .padding(.bottom)
            
            Button(isNew ? "메뉴 등록" : "확인") {
                onPrimaryTapped()
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.primaryColor700)
//            .background(isNew ? Color.blue : Color.gray.opacity(0.3))
            .foregroundColor(.white)
//            .foregroundColor(isNew ? .white : .black)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            
            
            
        }
        .padding()
//        .background(
//            Color(UIColor.systemBackground)
//                .shadow(color: .black.opacity(0.1), radius: 5, y: -2)
//        )
    }
}
