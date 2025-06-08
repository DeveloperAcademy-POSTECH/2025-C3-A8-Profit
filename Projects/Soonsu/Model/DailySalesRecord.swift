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
    var materialCost: Double
    var items: [SoldItemModel]

//    init(dateKey: String, revenue: Int, materialCost: Int, items: [SoldItemModel]) {
    init(dateKey: String, revenue: Int, materialCost: Double, items: [SoldItemModel]) {
        self.dateKey = dateKey
        self.revenue = revenue
        self.materialCost = materialCost
        self.items = items
    }

    var toDailySales: DailySales {
        DailySales(revenue: revenue, materialCost: materialCost, items: items.map { $0.toSoldItem })
    }
}
