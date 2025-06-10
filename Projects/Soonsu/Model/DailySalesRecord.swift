//
//  DailySalesRecord.swift
//  Soonsu
//
//  Created by coulson on 6/5/25.
//

import Foundation
import SwiftData
/*
@Model
class DailySalesRecord {
    var dateString: String // e.g., "2025-06-04"
    var revenue: Int
    var materialCost: Int
    @Relationship(deleteRule: .cascade) var soldItems: [SoldItemModel] = []

    init(dateString: String, revenue: Int, materialCost: Int, soldItems: [SoldItemModel]) {
        self.dateString = dateString
        self.revenue = revenue
        self.materialCost = materialCost
        self.soldItems = soldItems
    }
    
}
*/
@Model
final class DailySalesRecord {
    @Attribute(.unique) var dateKey: String
    var revenue: Int
//    var materialCost: Int
    var materialCost: Int
//    var items: [SoldItemModel]
    
    /// 판매된 항목들 (하위 테이블) – 삭제 시 함께 삭제
        @Relationship(deleteRule: .cascade)
        var items: [SoldItemModel] = []               // ← 기본값 필수

    
    // 기본 생성자
//    init(dateKey: String, revenue: Int, materialCost: Int, items: [SoldItemModel]) {
    init(dateKey: String,
             revenue: Int,
             materialCost: Int,
             items: [SoldItemModel] = []) {
        self.dateKey = dateKey
        self.revenue = revenue
        self.materialCost = materialCost
        self.items = items
    }

    /// SwiftData → 메모리 변환
    var toDailySales: DailySales {
        DailySales(revenue: revenue, materialCost: materialCost, items: items.map { $0.toSoldItem })
    }
}
