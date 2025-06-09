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
/*
 VStack(spacing: 16) {
 HStack {
 Image(systemName: "plus.circle.fill")
 .foregroundStyle(.blue)
 NavigationLink("재료 추가하기") {
 IngredientAddView(parsedIngredients: $parsedIngredients, onIngredientSelected: { selectedName in
 guard !parsedIngredients.contains(where: { $0.name == selectedName }) else { return }
 let newInfo = IngredientInfo(name: selectedName, amount: 10, unit:"g", unitPrice: 100)
 parsedIngredients.append(newInfo)
 })
 }
 }
 
 
 //
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
 
 
 
 Button(mode == .create ? "메뉴 등록" : "확인") {
 showProgressPopover = true
 }
 .font(.headline)
 .frame(maxWidth: .infinity)
 .padding()
 .background(Color.blue)
 .foregroundColor(.white)
 .clipShape(RoundedRectangle(cornerRadius: 12))
 }
 .padding()
 }
 
 }
 */
