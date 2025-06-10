//
//  ProfitViewModel.swift
//  Soonsu
//
//  Created by coulson on 6/3/25.
//

import Foundation
import SwiftUI
import Combine
import SwiftData

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
    func loadMenuMaster(from ingredients: [Ingredient]) {
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
//    func netProfit(for date: Date) -> Int? {
//        let key = format(date)
//        guard let sales = dailySalesData[key] else { return nil }
//        return sales.revenue - sales.materialCost - dailyFixedCost(for: date)
//    }
    func netProfit(for date: Date) -> Int? {
        guard let sales = salesData(for: date) else { return nil }
        return sales.revenue - Int(sales.materialCost) - dailyFixedCost(for: date)
    }
    
    func salesData(for date: Date) -> DailySales? {
        dailySalesData[format(date)]
    }

    
    // MARK: - 판매량 업데이트
//    func updateSales(for date: Date, soldItems: [SoldItem]) {
//            let revenue = soldItems.map { $0.price * $0.qty }.reduce(0, +)
//            let materialCost = soldItems.map {
//                let costPer = menuMaster.first(where: { $0.id == $0.id })?.materialCostPerUnit ?? 0
//                return costPer * $0.qty
//            }.reduce(0, +)
//
//            if soldItems.allSatisfy({ $0.qty == 0 }) {
//                dailySalesData.removeValue(forKey: format(date))
//            } else {
//                dailySalesData[format(date)] = DailySales(revenue: revenue, materialCost: materialCost, items: soldItems)
//            }
//        }
    func updateSales(for date: Date, soldItems: [SoldItem]) {
        let revenue = soldItems.map { $0.price * $0.qty }.reduce(0, +)
//        let materialCost = soldItems.map {
//            let costPer = menuMaster.first(where: { $0.id == $0.id })?.materialCostPerUnit ?? 0
//            return costPer * $0.qty
//        }.reduce(0, +)
        let materialCost = soldItems.map { item in
            let costPer = menuMaster.first(where: { $0.id == item.id })?.materialCostPerUnit ?? 0
            return costPer * item.qty
        }.reduce(0, +)
        
        let key = format(date)
        if soldItems.allSatisfy({ $0.qty == 0 }) {
            dailySalesData.removeValue(forKey: key)
        } else {
            dailySalesData[key] = DailySales(revenue: revenue, materialCost: materialCost, items: soldItems)
        }
    }
    
    // MARK: - 단축 통화 포맷 (예: 12345 → "1만")
//    func shortCurrency(_ amount: Int) -> String {
//        let number = Double(amount)
//        if abs(number) >= 10_000 {
//            return String(format: "%.0f만", number / 10_000)
//        }
//        return "\(amount)"
//    }
    func shortCurrency(_ amount: Int) -> String {
        let number = Double(amount)
        return abs(number) >= 10_000 ? String(format: "%.0f만", number / 10_000) : "\(amount)"
    }
    
    // MARK: - 요일을 한글로 반환 (일/월/화/…)
    func weekdayKorean(_ date: Date) -> String {
        let week = Calendar.current.component(.weekday, from: date)
        return ["일","월","화","수","목","금","토"][week - 1]
    }
}

/*
extension ProfitViewModel {
    func persistSalesData(_ context: ModelContext) {
        dailySalesData.forEach { (dateString, sales) in
            let existing = fetchSalesRecord(for: dateString, context: context)
            if let existing = existing {
                context.delete(existing)
            }

            let itemModels = sales.items.map {
                SoldItemModel(
                    id: $0.id,
                    name: $0.name,
                    price: $0.price,
                    qty: $0.qty,
                    image: $0.image,
                    parentDate: dateString
                )
            }

            let record = DailySalesRecord(
                dateKey: dateString,
                revenue: sales.revenue,
                materialCost: sales.materialCost,
                items: itemModels
            )

            context.insert(record)
        }

        do {
            try context.save()
            print("✅ 판매 데이터 저장 완료")
        } catch {
            print("❌ 저장 실패:", error)
        }
    }

    func loadPersistedSales(_ context: ModelContext) {
        let descriptor = FetchDescriptor<DailySalesRecord>()
        do {
            let records = try context.fetch(descriptor)
            var result: [String: DailySales] = [:]

            for record in records {
                let items = record.items.map {
                    SoldItem(id: $0.id, name: $0.name, price: $0.price, qty: $0.qty, image: $0.image)
                }
                result[record.dateKey] = DailySales(revenue: record.revenue, materialCost: record.materialCost, items: items)
            }

            dailySalesData = result
            print("✅ 판매 데이터 로드 완료: \(records.count)건")
        } catch {
            print("❌ 로드 실패:", error)
        }
    }

    private func fetchSalesRecord(for dateString: String, context: ModelContext) -> DailySalesRecord? {
        let predicate = #Predicate<DailySalesRecord> { $0.dateKey == dateString }
        let descriptor = FetchDescriptor<DailySalesRecord>(predicate: predicate)
        return try? context.fetch(descriptor).first
    }
}
*/
