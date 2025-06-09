//
//  DailySales.swift
//  Soonsu
//
//  Created by coulson on 6/3/25.
//

import Foundation

/// 하루 치 매출/원가 합산 정보
struct DailySales: Codable, Hashable {
    let revenue: Int
//    let materialCost: Int
    let materialCost: Double
    let items: [SoldItem]
}
