//
//  IngredientModifySheetComponent.swift
//  Soonsu
//
//  Created by Choi Jung In on 6/6/25.
//

import SwiftUI

struct IngredientModifyComponent: View {
    let ingredient: IngredientInfo
    @Binding var parsedIngredients: [IngredientInfo]
    @Environment(\.dismiss) private var dismiss
    
    @State private var segmentMode: SegmentMode = .auto
    @State private var purchasePrice: Double = 0
    @State private var purchaseAmount: Double = 0
    @State private var recipeAmount: Double = 0
    @State private var editableIngredient: IngredientInfo = IngredientInfo(name: "", amount: 0,  unit: "g" ,unitPrice: 0)
    
    enum SegmentMode: String, CaseIterable {
        case auto = "자동계산"
        case manual = "직접입력"
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
                HStack {
                    Button("삭제") {
                        if let index = parsedIngredients.firstIndex(where: { $0.id == editableIngredient.id }) {
                            parsedIngredients.remove(at: index)
                        }
                        dismiss()
                    }
                    .foregroundStyle(Color.red)
                    
                    Spacer()
                    
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
                .padding(.vertical)
                
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
                
                Text(editableIngredient.name)
                    .font(.title)
                    .bold()
                
                
                
                if segmentMode == .auto {
                    InputRowComponent(title: "레시피 수량", text: doubleToStringBinding(.constant(editableIngredient.amount)), isEnabled: false)
                    Divider()
                        .padding(.horizontal)
                    InputRowComponent(title: "단가", text: doubleToStringBinding(.constant(editableIngredient.unitPrice)), isEnabled: false)
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
                
                Spacer()
                
            

        }
        .padding()
        .onAppear {
            editableIngredient = ingredient
            recipeAmount = ingredient.amount
        }
    }
    
    private func updateUnitPrice() {
        
        let pricePerGram = purchasePrice / purchaseAmount
        let calculatedUnitPrice = pricePerGram * recipeAmount
        editableIngredient.unitPrice = calculatedUnitPrice
        editableIngredient.amount = recipeAmount
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
//
//#Preview {
//    IngredientModifyComponent(ingredient: IngredientInfo(
//        name: "양배추",
//        amount: 30,
//        unit: "g",
//        unitPrice: 1000),
//                          parsedIngredients: .constant([IngredientInfo(
//                            name: "양배추",
//                            amount: 30,
//                            unit: "g",
//                            unitPrice: 1000)]))
//}
