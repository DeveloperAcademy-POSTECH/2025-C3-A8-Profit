//
//  IngredientInfo.swift
//  HambJaeryoModal
//
//  Created by coulson on 5/29/25.
//

import SwiftUI
import SwiftData

@Model
final class IngredientEntity {
    @Attribute(.unique) var id: UUID                // 고유 식별자
    
    
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

struct IngredientInfo: Identifiable, Codable {
    // 리스트에 사용될 고유 id (JSON에 없음)
    var id: UUID = UUID()
    let name: String
    let amount: String
    let unitPrice: Int
    
    enum CodingKeys: String, CodingKey {
        case name, amount, unitPrice
    }
    
    // JSON → 모델 디코딩 시 id는 새로 생성
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.amount = try container.decode(String.self, forKey: .amount)
        self.unitPrice = try container.decode(Int.self, forKey: .unitPrice)
        self.id = UUID()
    }
    
    // 수동 생성 시 convenience 이니셜라이저
    init(name: String, amount: String, unitPrice: Int) {
        self.name = name
        self.amount = amount
        self.unitPrice = unitPrice
    }
}
