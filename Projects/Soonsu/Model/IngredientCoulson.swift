//
//  IngredientEntity.swift
//  Soonsu
//
//  Created by coulson on 6/3/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class IngredientCoulson {
    @Attribute(.unique) var id: UUID      // IngredientInfo.id와 동일하게 사용
    
    var menuName: String
    var menuPrice: Int
    var imageData: Data?
    
    var name: String
    var amount: String
    var unitPrice: Int
    var createdAt: Date
    
    init(
        menuName: String,
        menuPrice: Int,
        imageData: Data?,
        info: IngredientInfoCoulson,
        createdAt: Date = .now
    ) {
        self.id = info.id
        self.menuName = menuName
        self.menuPrice = menuPrice
        self.imageData = imageData
        
        self.name = info.name
        self.amount = info.amount
        self.unitPrice = info.unitPrice
        self.createdAt = createdAt
    }
}
