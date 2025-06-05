//
//  ProfitViewModel.swift
//  Soonsu
//
//  Created by coulson on 6/3/25.
//

import Foundation
import SwiftUI
import Combine

/// 수익(달력/고정비/일별매출) 화면 전용 ViewModel
class ProfitViewModel: ObservableObject {
    @Published var currentMonth: Date = Date()
    @Published var selectedDate: Date = Date()
    @Published var monthlyFixedCost: Int = 3_000_000  // 단위: 원
    @Published var operatingDays: Int = 30
    @Published var lastFixedCostUpdate: Date = Date()
    @Published var showSalesInputSheet: Bool = false
    @Published var showTips: Bool = false
    @Published var tipText: String = ""
    @Published var isFixedCostSet: Bool = false
    
    /// key: "yyyy-MM-dd", value: 하루 매출
    @Published var dailySalesData: [String: DailySales] = [:]
    
    
    @Published var salesByDate: [Date: [SoldItem]] = [:]
    
    /// IngredientEntity에서 가져온 사용자 메뉴 데이터
    @Published var menuMaster: [MenuItem] = []
    
    // MARK: - 사용자 정의 메뉴 불러오기
    func loadMenuMaster(from ingredients: [IngredientEntity]) {
        let grouped = Dictionary(grouping: ingredients, by: { $0.menuName })
        
        menuMaster = grouped.compactMap { (menuName, entries) in
            guard let first = entries.first else { return nil }
            let totalCost = entries.map { $0.unitPrice }.reduce(0, +)
            return MenuItem(
                id: menuName.hashValue,
                name: menuName,
                price: first.menuPrice,
                materialCostPerUnit: totalCost,
                image: "" // 실제 UIImage는 View에서 imageData를 직접 해석
            )
        }
    }


    
    // MARK: - 날짜 포맷터
    private func format(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }
    
    // MARK: - 일할 고정비
    func dailyFixedCost(for date: Date) -> Int {
        let days = operatingDays > 0 ? operatingDays : Calendar.current.range(of: .day, in: .month, for: date)!.count
        return days > 0 ? monthlyFixedCost / days : 0
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
            let revenue = soldItems.map { $0.price * $0.qty }.reduce(0, +)
            let materialCost = soldItems.map {
                let costPer = menuMaster.first(where: { $0.id == $0.id })?.materialCostPerUnit ?? 0
                return costPer * $0.qty
            }.reduce(0, +)

            if soldItems.allSatisfy({ $0.qty == 0 }) {
                dailySalesData.removeValue(forKey: format(date))
            } else {
                dailySalesData[format(date)] = DailySales(revenue: revenue, materialCost: materialCost, items: soldItems)
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
        let week = Calendar.current.component(.weekday, from: date)
        return ["일","월","화","수","목","금","토"][week - 1]
    }
}
