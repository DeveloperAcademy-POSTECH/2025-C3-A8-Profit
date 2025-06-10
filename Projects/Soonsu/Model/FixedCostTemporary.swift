//
//  FixedCostTemporary.swift
//  Soonsu
//
//  Created by JiJooMaeng on 6/9/25.
//

import Foundation
import SwiftData

@Model
class FixedCostTemporary {
    var date: Date?
    var monthlyFixedCost: Int
    var operatingDays: Int

    init(date: Date? = Date(), monthlyFixedCost: Int, operatingDays: Int) {
        self.date = date
        self.monthlyFixedCost = monthlyFixedCost
        self.operatingDays = operatingDays
    }
}
