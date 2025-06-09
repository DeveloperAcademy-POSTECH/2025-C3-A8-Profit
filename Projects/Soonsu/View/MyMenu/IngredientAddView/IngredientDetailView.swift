//
//  IngredientModifySheetComponent.swift
//  Soonsu
//
//  Created by Choi Jung In on 6/6/25.
//

import SwiftUI

struct IngredientDetailView: View {
    
    var ingredient: IngredientInfo
    @Binding var parsedIngredients: [IngredientInfo]
    @Environment(\.dismiss) private var dismiss
    
    @State private var segmentMode: SegmentMode = .auto
    @State private var purchasePrice: Double = 0
    @State private var purchaseAmount: Double = 0
    @State private var recipeAmount: Double = 0
    
    enum SegmentMode: String, CaseIterable {
        case auto = "자동계산"
        case manual = "직접입력"
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
                
                Picker("모드", selection: $segmentMode) {
                    ForEach(SegmentMode.allCases, id: \.self) {
                        segmentMode in Text(segmentMode.rawValue).tag(segmentMode)
                    }
                }
                .pickerStyle(.segmented)
                Image(uiImage: UIImage(named: ingredient.name) ?? UIImage(named: "포항초")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 128, height: 128)
                
            Text(ingredient.name)
                    .font(.title)
                    .bold()
                
                
                
                if segmentMode == .auto {
                    InputRowComponent(title: "레시피 수량", text: doubleToStringBinding(.constant(ingredient.amount)), isEnabled: false)
                    Divider()
                        .padding(.horizontal)
                    InputRowComponent(title: "단가", text: doubleToStringBinding(.constant(ingredient.unitPrice)), isEnabled: false)
                } else {
                    Group {
                        InputRowComponent(title: "구매 금액", placeholder: "1000", text: doubleToStringBinding($purchasePrice), keyboardType: .numberPad, unit: "원")
                        Divider()
                            .padding(.horizontal)
                        InputRowComponent(title: "구매 수량", placeholder: "500", text: doubleToStringBinding($purchaseAmount), keyboardType: .numberPad, unit: "g")
                        Divider()
                            .padding(.horizontal)
                        InputRowComponent(title: "레시피 수량", placeholder: "30", text: doubleToStringBinding($recipeAmount), keyboardType: .numberPad, unit: "g")
                    }
                }
            
            Button {
                if segmentMode == .manual {
                    let pricePerGram = purchasePrice / purchaseAmount
                    let calculatedUnitPrice = pricePerGram * recipeAmount
                    let updated = IngredientInfo(
                        name: ingredient.name,
                        amount: recipeAmount,
                        unit: ingredient.unit,
                        unitPrice: calculatedUnitPrice
                    )
                    if let index = parsedIngredients.firstIndex(where: { $0.id == ingredient.id }) {
                        parsedIngredients[index] = updated
                    } else {
                        parsedIngredients.append(updated)
                    }
                    
                    dismiss()
                }
            } label: {
                Text("재료 등록하기")
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.blue)
            .cornerRadius(10)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
                
            Spacer()
                
            

        }
        .padding()
        .onAppear {
//            editableIngredient = ingredient
            recipeAmount = ingredient.amount
        }
    }
    
    private func updateUnitPrice() {
        
        let pricePerGram = purchasePrice / purchaseAmount
        let calculatedUnitPrice = pricePerGram * recipeAmount
//        ingredient.unitPrice = calculatedUnitPrice
//        ingredient.amount = recipeAmount
    }
    
    private func doubleToStringBinding(_ doubleBinding: Binding<Double>) -> Binding<String> {
        Binding<String>(
            get: {
                String(format: "%.0f", doubleBinding.wrappedValue)
            },
            set: { newValue in
                if let value = Double(newValue) {
                    doubleBinding.wrappedValue = value
                }
            }
        )
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var ingredients: [IngredientInfo] = [
            IngredientInfo(name: "양배추", amount: 30, unit: "g", unitPrice: 1000)
        ]

        var body: some View {
            IngredientDetailView(
                ingredient: ingredients[0],
                parsedIngredients: $ingredients
            )
        }
    }

    return PreviewWrapper()
}

