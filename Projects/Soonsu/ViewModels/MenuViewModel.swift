//
//  MenuViewModel.swift
//  Soonsu
//
//  Created by coulson on 6/3/25.
//

import Foundation
import SwiftData
import SwiftUI

/// 메뉴/재료 관리 전용 ViewModel
/// - SwiftData 엔티티(IngredientEntity) CRUD를 담당
class MenuViewModel: ObservableObject {
    @Environment(\.modelContext) private var context

    /// SwiftData에 저장된 모든 IngredientEntity를 최신순(createdAt)으로 가져옴
    @Published var allIngredients: [IngredientEntity] = []
    
    init() {
        fetchAllIngredients()
    }
    
    /// 전체 IngredientEntity fetch
    func fetchAllIngredients() {
        let descriptor = FetchDescriptor<IngredientEntity>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        do {
            allIngredients = try context.fetch(descriptor)
        } catch {
            print("❌ fetchAllIngredients error:", error)
            allIngredients = []
        }
    }
    
    /// 특정 메뉴명에 속한 IngredientEntity만 fetch
    func fetchEntities(for menuName: String) -> [IngredientEntity] {
        let predicate = #Predicate<IngredientEntity> { $0.menuName == menuName }
        let descriptor = FetchDescriptor<IngredientEntity>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Fetch error for \(menuName):", error)
            return []
        }
    }
    
    /// 새로운 메뉴+재료 정보를 SwiftData에 저장
    func saveIngredients(
        menuName: String,
        menuPrice: Int,
        image: UIImage?,
        ingredientInfos: [IngredientInfo]
    ) {
        let imageData = image?.jpegData(compressionQuality: 0.8)
        for info in ingredientInfos {
            let entity = IngredientEntity(
                menuName:  menuName,
                menuPrice: menuPrice,
                imageData: imageData,
                info:      info
            )
            context.insert(entity)
        }
        do {
            try context.save()
            fetchAllIngredients()
        } catch {
            print("❌ saveIngredients error:", error)
        }
    }
}
