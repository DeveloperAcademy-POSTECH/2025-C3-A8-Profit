//
//  IngredientModifySheetComponent.swift
//  Soonsu
//
//  Created by Choi Jung In on 6/6/25.
//

import SwiftUI

struct IngredientDetailView: View {
    let ingredient: IngredientInfo
    @Binding var ingredients: [IngredientInfo]
    
    @Environment(\.dismiss) private var dismiss

    @State private var segmentMode: SegmentMode = .auto
    @State private var purchasePrice: Int = 2000
    @State private var purchaseAmount: String = "200g"
    @State private var recipeAmount: String = ""
    
    @State private var amountString: String = ""
    @State private var unitString: String = ""
    
    @State private var editableIngredient: IngredientInfo = IngredientInfo(name: "", amount: "", unitPrice: 100)
    
    

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
                    TextRowComponent(title: "수량", content: ingredient.amount)
                    Divider()
                        .padding(.horizontal)
                    TextRowComponent(title: "단가", content: "\(ingredient.unitPrice)원")
                    Text("Kamis(농산물유통정보), 한국소비자원 참가격의 데이터입니다")
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
            Button {
                // MARK: 재료 추가하는 코드
                dismiss()
            } label: {
                Text("재료추가하기")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.blue)
            .cornerRadius(10)
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
}

