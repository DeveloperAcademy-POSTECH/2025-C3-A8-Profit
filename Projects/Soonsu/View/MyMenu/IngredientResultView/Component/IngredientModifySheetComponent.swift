//
//  IngredientModifySheetComponent.swift
//  Soonsu
//
//  Created by Choi Jung In on 6/6/25.
//

import SwiftUI

struct IngredientModifySheet: View {
    let ingredient: IngredientInfo
    @Binding var parsedIngredients: [IngredientInfo]
    @Environment(\.dismiss) private var dismiss
    
    @State private var segmentMode: SegmentMode = .auto
    @State private var purchasePrice: String = ""
    @State private var purchaseAmount: String = ""
    @State private var recipeAmount: String = ""
    @State private var editableIngredient: IngredientInfo = IngredientInfo(name: "", amount: "", unitPrice: 0)
    
    enum SegmentMode: String, CaseIterable {
        case auto = "자동계산"
        case manual = "직접입력"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                Picker("모드", selection: $segmentMode) {
                    ForEach(SegmentMode.allCases, id: \.self) {
                        segmentMode in Text(segmentMode.rawValue).tag(segmentMode)
                    }
                }
                .pickerStyle(.segmented)
                
                Image(systemName: "photo")
                    .font(.system(size: 48))
                    .foregroundStyle(Color.gray.opacity(0.2))
                
                Text(editableIngredient.name)
                    .font(.title)
                    .bold()
                
                
                
                if segmentMode == .auto {
                    InputRowComponent(title: "수량", text: .constant(editableIngredient.amount), isEnabled: false)
                    Divider()
                        .padding(.horizontal)
                    InputRowComponent(title: "단가", text: .constant("\(editableIngredient.unitPrice.formatted())원"), isEnabled: false)
                } else {
                    Group {
                        InputRowComponent(title: "구매 금액", placeholder: "예: 1000", text: $purchasePrice, keyboardType: .numberPad)
                        Divider()
                            .padding(.horizontal)
                        InputRowComponent(title: "구매 수량", placeholder: "예: 500g", text: $purchaseAmount, keyboardType: .numberPad)
                        Divider()
                            .padding(.horizontal)
                        InputRowComponent(title: "레시피 수량", placeholder: "예: 30g", text: $recipeAmount, keyboardType: .numberPad)
                    }
                }
                
                Spacer()
            }
            .padding()
            .onAppear {
                editableIngredient = ingredient
                recipeAmount = ingredient.amount
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("삭제") {
                        if let index = parsedIngredients.firstIndex(where: { $0.id == editableIngredient.id }) {
                            parsedIngredients.remove(at: index)
                        }
                        dismiss()
                    }
                    .foregroundStyle(Color.red)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("수정") {
                        if segmentMode == .manual {
                            updateUnitPrice()
                        }
                        if let index = parsedIngredients.firstIndex(where: { $0.id == editableIngredient.id }) {
                            parsedIngredients[index] = editableIngredient
                        }
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func updateUnitPrice() {
        guard let price = Int(purchasePrice),
              let recipeAmountValue = Double(recipeAmount.filter("0123456789.".contains)),
              let purchaseAmountValue = Double(purchaseAmount.filter("0123456789.".contains)),
              purchaseAmountValue != 0 else {
            return
        }

        let pricePerGram = Double(price) / purchaseAmountValue
        let calculatedUnitPrice = Int(pricePerGram * recipeAmountValue)
        editableIngredient.unitPrice = calculatedUnitPrice
        editableIngredient.amount = recipeAmount
    }
}

#Preview {
    IngredientModifySheet(ingredient: IngredientInfo(
        name: "양배추",
        amount: "30g",
        unitPrice: 1000),
                          parsedIngredients: .constant([IngredientInfo(
                            name: "양배추",
                            amount: "30g",
                            unitPrice: 1000)]))
}
