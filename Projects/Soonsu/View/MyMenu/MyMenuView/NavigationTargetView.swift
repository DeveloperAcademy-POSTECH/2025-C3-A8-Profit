//
//  NavigationTargetView.swift
//  Soonsu
//
//  Created by coulson on 6/19/25.
//

import SwiftUI

struct NavigationTargetView: View {
    let data: IngredientNavigationData
    @Binding var selectedMenuName: String
    @Binding var showAddMenu: Bool

    var body: some View {
        let menuName = data.menuName
        let menuPrice = data.menuPrice
        let image = data.image
        let ingredients = data.ingredients

        if data.isNew {
            // 신규 등록 경로
            IngredientResultView(
                isNew: true,
                selectedMenuName: $selectedMenuName,
                showAddMenu: $showAddMenu,
                menuName: menuName,
                menuPrice: menuPrice,
                image: image,
                parsedIngredients: ingredients
            )
        } else {
            // 기존 수정 경로
            IngredientEditView(
                selectedMenuName: $selectedMenuName,
                menuName: menuName,
                menuPrice: menuPrice,
                image: image,
                parsedIngredients: ingredients
            )
        }
    }
}
