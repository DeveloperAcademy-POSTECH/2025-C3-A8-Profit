//
//  IngredientModifySheet.swift
//  Soonsu
//
//  Created by Choi Jung In on 6/10/25.
//

import SwiftUI

extension View {
    func ingredientModifySheet(
//        isPresented: Binding<Bool>,
//        ingredients: Binding<[IngredientInfo]>,
//        selectedIngredient: Binding<IngredientInfo?>
        selectedIngredient: Binding<IngredientInfo?>,
                ingredients: Binding<[IngredientInfo]>
        
    ) -> some View {
//        self.sheet(isPresented: isPresented) { 
//            if let selIngredient = selectedIngredient.wrappedValue,
//               let index = ingredients.wrappedValue.firstIndex(where: { $0.id == selIngredient.id }) {
//                
//                IngredientModifyComponent(
//                    ingredient: ingredients.wrappedValue[index],
//                    ingredients: ingredients
//                )
//            }
//        }
        self.sheet(item: selectedIngredient) { selIngredient in
                    if let index = ingredients.wrappedValue.firstIndex(where: { $0.id == selIngredient.id }) {
                        IngredientModifyComponent(
                            ingredient: ingredients.wrappedValue[index],
                            ingredients: ingredients
                        )
                    } else {
                        Text("재료를 찾을 수 없습니다.")
                    }
                }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
