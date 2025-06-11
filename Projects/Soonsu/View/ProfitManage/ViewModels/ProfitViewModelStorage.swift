//  ProfitViewModelStorage.swift
//  Soonsu
//
//  Created by coulson on 6/5/25.

import Foundation
import SwiftData

// MARK: - 월별 고정비/영업일수 저장용 모델
@Model
final class MonthlyFixedCostRecord {
    @Attribute(.unique) var monthKey: String // yyyy-MM 형식
    var fixedCost: Int
    var operatingDays: Int
    var lastUpdated: Date

    init(monthKey: String, fixedCost: Int, operatingDays: Int, lastUpdated: Date) {
        self.monthKey = monthKey
        self.fixedCost = fixedCost
        self.operatingDays = operatingDays
        self.lastUpdated = lastUpdated
    }
}

// MARK: - ProfitViewModel 확장: 월별 고정비 및 판매 데이터 저장/불러오기
extension ProfitViewModel {
    func loadMonthlyFixedCost(from context: ModelContext) {
        let key = formatMonth(currentMonth)
//        let predicate = #Predicate<MonthlyFixedCostRecord> { $0.monthKey == key }
        let predicate = #Predicate<MonthlyFixedCostRecord> { record in record.monthKey == key }
        let descriptor = FetchDescriptor<MonthlyFixedCostRecord>(predicate: predicate)

        do {
            if let record = try context.fetch(descriptor).first {
                monthlyFixedCost = record.fixedCost
                operatingDays = record.operatingDays
                lastFixedCostUpdate = record.lastUpdated
                isFixedCostSet = true
            } else {
                monthlyFixedCost = 3_000_000
                operatingDays = Calendar.current.range(of: .day, in: .month, for: currentMonth)?.count ?? 30
                isFixedCostSet = false
            }
        } catch {
            print("❌ 고정비 로드 실패:", error)
        }
    }

    func saveMonthlyFixedCost(to context: ModelContext) {
        print("📦 고정비 불러오기 시도")
        let key = formatMonth(currentMonth)
//        let predicate = #Predicate<MonthlyFixedCostRecord> { $0.monthKey == key }
        let predicate = #Predicate<MonthlyFixedCostRecord> { record in record.monthKey == key }
        let descriptor = FetchDescriptor<MonthlyFixedCostRecord>(predicate: predicate)

        do {
            if let existing = try context.fetch(descriptor).first {
                context.delete(existing)
            }

            let record = MonthlyFixedCostRecord(
                monthKey: key,
                fixedCost: monthlyFixedCost,
                operatingDays: operatingDays,
                lastUpdated: Date()
            )

            context.insert(record)
            try context.save()
            print("✅ 고정비 저장 완료")
        } catch {
            print("❌ 고정비 저장 실패:", error)
        }
    }

    func persistSalesData(_ context: ModelContext) {
        dailySalesData.forEach { (dateString, sales) in
            if let existing = fetchSalesRecord(for: dateString, context: context) {
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
        print("📦 판매 데이터 불러오기 시도")
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
//        let predicate = #Predicate<DailySalesRecord> { $0.dateKey == dateString }
        let predicate = #Predicate<DailySalesRecord> { record in
            record.dateKey == dateString
        }
        let descriptor = FetchDescriptor<DailySalesRecord>(predicate: predicate)
        return try? context.fetch(descriptor).first
    }

    private func formatMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter.string(from: date)
    }
    
    func loadFromStorage(context: ModelContext) {
        print("🔄 loadFromStorage 호출됨")
            loadMonthlyFixedCost(from: context)
            loadPersistedSales(context)
        }
}



/*
//  ProfitViewModelStorage.swift
//  Soonsu
//
//  Created by coulson on 6/5/25.

import Foundation
import SwiftData

// MARK: - 월별 고정비/영업일수 저장용 모델
@Model
final class MonthlyFixedCostRecord {
    @Attribute(.unique) var monthKey: String // yyyy-MM 형식
    var fixedCost: Int
    var operatingDays: Int
    var lastUpdated: Date
    
    init(monthKey: String, fixedCost: Int, operatingDays: Int, lastUpdated: Date) {
        self.monthKey = monthKey
        self.fixedCost = fixedCost
        self.operatingDays = operatingDays
        self.lastUpdated = lastUpdated
    }
}

// MARK: - ProfitViewModel 확장: 월별 고정비 및 판매 데이터 저장/불러오기
extension ProfitViewModel {
    func loadMonthlyFixedCost(from context: ModelContext) {
        let key = formatMonth(currentMonth)
        let predicate = #Predicate<MonthlyFixedCostRecord> { $0.monthKey == key }
        let descriptor = FetchDescriptor<MonthlyFixedCostRecord>(predicate: predicate)
        
        do {
            if let record = try context.fetch(descriptor).first {
                monthlyFixedCost = record.fixedCost
                operatingDays = record.operatingDays
                lastFixedCostUpdate = record.lastUpdated
                isFixedCostSet = true
            } else {
                monthlyFixedCost = 3_000_000
                operatingDays = Calendar.current.range(of: .day, in: .month, for: currentMonth)?.count ?? 30
                isFixedCostSet = false
            }
        } catch {
            print("❌ 고정비 로드 실패:", error)
        }
    }
    
    func saveMonthlyFixedCost(to context: ModelContext) {
        let key = formatMonth(currentMonth)
//        let predicate = #Predicate<MonthlyFixedCostRecord> { $0.monthKey == key }
//        let descriptor = FetchDescriptor<MonthlyFixedCostRecord>(predicate: predicate)
        let descriptor = FetchDescriptor<MonthlyFixedCostRecord>( predicate: NSPredicate(format: "monthKey == %@", key)
        
        do {
            if let existing = try context.fetch(descriptor).first {
                context.delete(existing)
            }
            
            let record = MonthlyFixedCostRecord(
                monthKey: key,
                fixedCost: monthlyFixedCost,
                operatingDays: operatingDays,
                lastUpdated: Date()
            )
            
            context.insert(record)
            try context.save()
            print("✅ 고정비 저장 완료")
        } catch {
            print("❌ 고정비 저장 실패:", error)
        }
    }
    
    func persistSalesData(_ context: ModelContext) {
        dailySalesData.forEach { (dateString, sales) in
            if let existing = fetchSalesRecord(for: dateString, context: context) {
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
    
    private func formatMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter.string(from: date)
    }
    
//    @MainActor private func vmContext() throws -> ModelContext? {
//        let container = try? ModelContainer(for: MonthlyFixedCostRecord.self, DailySalesRecord.self, SoldItemModel.self)
//        return container?.mainContext
//    }
    @MainActor
        func mainActorContext() -> ModelContext? {
            let container = try? ModelContainer(for: MonthlyFixedCostRecord.self, DailySalesRecord.self, SoldItemModel.self)
            return container?.mainContext
        }

}
*/


