//
//  ProfitViewModel.swift
//  Soonsu
//
//  Created by coulson on 6/3/25.
//

import Foundation
import SwiftUI

/// 수익(달력/고정비/일별매출) 화면 전용 ViewModel
class ProfitViewModel: ObservableObject {
    @Published var currentMonth: Date = Date()
    @Published var selectedDate: Date = Date()
    @Published var monthlyFixedCost: Int = 3_000_000  // 단위: 원
    @Published var lastFixedCostUpdate: Date = Date()
    @Published var showSalesInputSheet: Bool = false
    @Published var showTips: Bool = false
    @Published var tipText: String = ""
    
    /// key: "yyyy-MM-dd", value: 하루 매출
    @Published var dailySalesData: [String: DailySales] = [
        "2024-06-26": DailySales(
            revenue: 325_000,
            materialCost: 125_000,
            items: [
                SoldItem(id: 1, name: "함박 스테이크", price: 15000, qty: 10, image: ""),
                SoldItem(id: 2, name: "돈까스", price: 12000, qty: 8, image: ""),
                SoldItem(id: 3, name: "샐러드", price: 8000, qty: 7, image: "")
            ]
        )
    ]
    
    /// 메뉴 마스터 데이터 (예시)
    @Published var menuMaster: [MenuItem] = [
        MenuItem(id: 1, name: "함박 스테이크", price: 15000, materialCostPerUnit: 5000, image: ""),
        MenuItem(id: 2, name: "돈까스", price: 12000, materialCostPerUnit: 4000, image: ""),
        MenuItem(id: 3, name: "샐러드", price: 8000, materialCostPerUnit: 2500, image: ""),
        MenuItem(id: 4, name: "파스타", price: 13000, materialCostPerUnit: 4500, image: ""),
        MenuItem(id: 5, name: "음료수", price: 2000, materialCostPerUnit: 500, image: "")
    ]
    
    // MARK: - 날짜 포맷터
    private func format(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }
    
    // MARK: - 일할 고정비
    func dailyFixedCost(for date: Date) -> Int {
        let daysInMonth = Calendar.current.range(of: .day, in: .month, for: date)!.count
        return monthlyFixedCost / daysInMonth
    }
    
    // MARK: - 순이익 계산
    func netProfit(for date: Date) -> Int? {
        let key = format(date)
        guard let sales = dailySalesData[key] else { return nil }
        return sales.revenue - sales.materialCost - dailyFixedCost(for: date)
    }
    
    func salesData(for date: Date) -> DailySales? {
        dailySalesData[format(date)]
    }
    
    // MARK: - 판매량 업데이트
    func updateSales(for date: Date, soldItems: [SoldItem]) {
        let revenue = soldItems.reduce(0) { $0 + $1.price * $1.qty }
        let materialCost = soldItems.reduce(0) { partial, item in
            let costPer = menuMaster.first(where: { $0.id == item.id })?.materialCostPerUnit ?? 0
            return partial + costPer * item.qty
        }
        if soldItems.filter({ $0.qty > 0 }).isEmpty {
            dailySalesData.removeValue(forKey: format(date))
        } else {
            dailySalesData[format(date)] = DailySales(
                revenue: revenue,
                materialCost: materialCost,
                items: soldItems
            )
        }
    }
    
    // MARK: - 단축 통화 포맷 (예: 12345 → "1만")
    func shortCurrency(_ amount: Int) -> String {
        let number = Double(amount)
        if abs(number) >= 10_000 {
            return String(format: "%.0f만", number / 10_000)
        }
        return "\(amount)"
    }
    
    // MARK: - 요일을 한글로 반환 (일/월/화/…)
    func weekdayKorean(_ date: Date) -> String {
        let idx = Calendar.current.component(.weekday, from: date)
        return ["일","월","화","수","목","금","토"][idx - 1]
    }
}
