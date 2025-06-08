//
//  OverheadCost.swift
//  Soonsu
//
//  Created by JiJooMaeng on 6/8/25.
//



import Foundation
import SwiftData

@Model
class OverheadCost: Identifiable {
    var id: UUID
    var category: OverheadCategory
    var createdAt: Date

    init(category: OverheadCategory, id: UUID = UUID(), createdAt: Date = Date()) {
        self.id = id
        self.category = category
        self.createdAt = createdAt
    }
}

enum OverheadCategory: String, Codable, CaseIterable {
    case rent = "임차료"
    case internet = "인터넷/통신비"
    case advertising = "광고선전비"
    case interest = "이자비용"
    case etc = "기타/잡비"
    case utilities = "수도광열비"
    case insurance = "보험료"
    case depreciation = "감가상각비"
    case tax = "공과금"
    case rental = "렌탈료"
}

@Model
class BasicCost {
    var overheadCost: OverheadCost
    var amount: Int

    init(overheadCost: OverheadCost, amount: Int) {
        self.overheadCost = overheadCost
        self.amount = amount
    }
}

@Model
class UtilityCost {
    var overheadCost: OverheadCost
    var water: Int
    var electricity: Int
    var gas: Int

    init(overheadCost: OverheadCost, water: Int, electricity: Int, gas: Int) {
        self.overheadCost = overheadCost
        self.water = water
        self.electricity = electricity
        self.gas = gas
    }
}

@Model
class InsuranceCost {
    var overheadCost: OverheadCost
    var detail: String
    var amount: Int
    var period: String

    init(overheadCost: OverheadCost, detail: String, amount: Int, period: String) {
        self.overheadCost = overheadCost
        self.detail = detail
        self.amount = amount
        self.period = period
    }
}

@Model
class DepreciationCost {
    var overheadCost: OverheadCost
    var item: String
    var purchasePrice: Int
    var usefulLifeYears: Int
    var residualValue: Int

    init(overheadCost: OverheadCost, item: String, purchasePrice: Int, usefulLifeYears: Int, residualValue: Int) {
        self.overheadCost = overheadCost
        self.item = item
        self.purchasePrice = purchasePrice
        self.usefulLifeYears = usefulLifeYears
        self.residualValue = residualValue
    }
}

@Model
class RentalCost {
    var overheadCost: OverheadCost
    var detail: String
    var amount: Int

    init(overheadCost: OverheadCost, detail: String, amount: Int) {
        self.overheadCost = overheadCost
        self.detail = detail
        self.amount = amount
    }
}

@Model
class TaxCost {
    var overheadCost: OverheadCost
    var detail: String
    var amount: Int
    var period: String

    init(overheadCost: OverheadCost, detail: String, amount: Int, period: String) {
        self.overheadCost = overheadCost
        self.detail = detail
        self.amount = amount
        self.period = period
    }
}
