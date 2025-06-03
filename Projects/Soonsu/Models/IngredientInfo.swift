//
//  IngredientInfo.swift
//  Soonsu
//
//  Created by coulson on 6/3/25.
//

import Foundation
import SwiftData
import SwiftUI

/// AI로부터 받은 재료 정보 (UIKit/SwiftUI에서 식별자로 사용됨)
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
