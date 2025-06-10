//
//  IngredientModifySheetComponent.swift
//  Soonsu
//
//  Created by Choi Jung In on 6/6/25.
//

import SwiftUI
import SwiftData

struct IngredientModifyComponent: View {
    
    @Environment(\.modelContext) private var context
    
    let ingredient: IngredientInfo
    @Binding var ingredients: [IngredientInfo]
    
    @Environment(\.dismiss) private var dismiss

    @State private var segmentMode: SegmentMode = .auto
    @State private var purchasePrice: Int = 2000
    @State private var purchaseAmount: String = "200g"
    @State private var recipeAmount: String = ""
    
    @State private var amountString: String = ""
    @State private var unitString: String = ""
    
    @State private var editableIngredient: IngredientInfo = IngredientInfo(name: "", amount: "", unitPrice: 0)
    
    

    enum SegmentMode: String, CaseIterable {
        case auto = "자동계산"
        case manual = "직접입력"
    }

    var body: some View {
        VStack(spacing: 16) {

            HStack {
                Button("삭제") {
                    if let index = ingredients.firstIndex(where: { $0.id == editableIngredient.id }) {
                        ingredients.remove(at: index)
                    }
                    dismiss()
                }
                .foregroundStyle(Color.red)

                Spacer()

                Button("수정") {
                    if segmentMode == .manual {
                        updateUnitPrice()
                    }
                    if let index = ingredients.firstIndex(where: { $0.id == editableIngredient.id }) {
                        ingredients[index] = editableIngredient
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
            Image(uiImage: UIImage(named: ingredient.name) ?? UIImage(named: "양배추")!)
                .resizable()
                .scaledToFill()
                .frame(width: 128, height: 128)

            Text(ingredient.name)
                .font(.title)
                .bold()
                .padding(.bottom)
            
            
            if segmentMode == .auto {
                
                VStack {
                    TextRowComponent(title: "레시피 수량", content: ingredient.amount)
                    Divider()
                        .padding(.horizontal)
                    TextRowComponent(title: "단가", content: "\(ingredient.unitPrice)원")
                    Text("Gemini가 예상한 메뉴의 수량과 단가입니다")
                        .foregroundStyle(.secondary)
                        .font(.caption2)
                        .padding(.top, 24)
                }
            } else {
                TextFieldRowIntComponent(title: "구매 금액", content: $purchasePrice)
                Divider()
                    .padding(.horizontal)
                
                TextFieldRowStringComponent(title: "구매량", content: $purchaseAmount)
                Divider()
                    .padding(.horizontal)
                TextFieldRowStringComponent(title: "레시피 수량", content: $recipeAmount)
            }
            Spacer()
        }
        .padding()
        .onAppear {
            editableIngredient = ingredient
            recipeAmount = ingredient.amount
            purchasePrice = ingredient.unitPrice
            purchaseAmount = recipeAmount
        }
    }

    private func updateUnitPrice() {
        var purchaseAmountString: String = ""
        var recipeAmountString: String = ""
        
        (purchaseAmountString,_) = splitContentIntoAmountAndUnit(text: purchaseAmount)
        (recipeAmountString,_) = splitContentIntoAmountAndUnit(text: recipeAmount)
        
        

        let pricePerGram = purchasePrice / Int(purchaseAmountString)!
        let calculatedUnitPrice = pricePerGram * Int(recipeAmountString)!
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
