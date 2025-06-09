//
//  IngredientEntity.swift
//  Soonsu
//
//  Created by coulson on 6/3/25.
//

import Foundation
import SwiftData
import SwiftUI

/*
@Model
final class Ingredient {
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
        info: IngredientInfo,
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
*/
@Model
final class Ingredient {
    @Attribute(.unique) var id: UUID                // 고유 식별자
    
    
    var menuName: String
    var menuPrice: Int
    var imageData: Data?
    
    
    var name: String
    var amount: Double
    var unit: String
    var unitPrice: Double
    var createdAt: Date
    
    
    init(
        menuName: String,
        menuPrice: Int,
        imageData: Data?,
        info: IngredientInfo,
        createdAt: Date = .now
    ) {
        self.id = info.id
        self.menuName = menuName
        self.menuPrice = menuPrice
        self.imageData = imageData
        
        
        self.name = info.name
        self.amount = info.amount
        self.unit = info.unit
        self.unitPrice = info.unitPrice
        self.createdAt = createdAt
    }
}
