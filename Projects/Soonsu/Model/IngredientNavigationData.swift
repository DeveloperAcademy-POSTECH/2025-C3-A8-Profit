//
//  IngredientNavigationData.swift
//  Soonsu
//
//  Created by coulson on 6/19/25.
//

import SwiftUI

struct IngredientNavigationData: Identifiable, Hashable {
    var id: String { menuName } // 메뉴명 기준으로 구분

    let menuName: String
    let menuPrice: String
    let image: UIImage?
    let ingredients: [IngredientInfo]
    let isNew: Bool

    static func == (lhs: IngredientNavigationData, rhs: IngredientNavigationData) -> Bool {
        lhs.menuName == rhs.menuName
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(menuName)
    }
}
