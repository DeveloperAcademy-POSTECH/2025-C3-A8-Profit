//
//  IngredientModifySheet.swift
//  Soonsu
//
//  Created by Choi Jung In on 6/10/25.
//

import SwiftUI

extension View {
    func ingredientModifySheet(
        isPresented: Binding<Bool>,
        ingredients: Binding<[IngredientInfo]>,
        selectedIngredient: Binding<IngredientInfo?>
    ) -> some View {
        self.sheet(isPresented: isPresented) {
            if let selIngredient = selectedIngredient.wrappedValue,
               let index = ingredients.wrappedValue.firstIndex(where: { $0.id == selIngredient.id }) {
                
                IngredientModifyComponent(
                    ingredient: ingredients.wrappedValue[index],
                    ingredients: ingredients
                )
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
