//
//  IngredientModifySheetComponent.swift
//  Soonsu
//
//  Created by Choi Jung In on 6/6/25.
//

import SwiftUI

struct IngredientModifySheet: View {
    let ingredient: IngredientInfo
    
    @State private var segmentMode: SegmentMode = .auto
    @State private var customAmount: String = ""
    
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
                
                Text(ingredient.name)
                    .font(.title)
                    .bold()
                
                if segmentMode == .auto {
                    Text("수량: \(ingredient.amount)")
                    Text("단가: \(ingredient.unitPrice.formatted())원")
                } else {
                    TextField("수량입력", text: $customAmount)
                        .textFieldStyle(.plain)
                        .keyboardType(.default)
                }
                
                Spacer()
            }
            .padding()
            .onAppear {
                customAmount = ingredient.amount
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("삭제")
                        .foregroundStyle(Color.red)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Text("수정")
                        .foregroundStyle(Color.blue)
                }
            }
        }
    }
}

#Preview {
    IngredientModifySheet(ingredient: IngredientInfo(name: "양배추", amount: "30g", unitPrice: 1000))
}
