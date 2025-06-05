//
//  MenuViewModel.swift
//  Soonsu
//
//  Created by coulson on 6/3/25.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

/// 메뉴/재료 관리 전용 ViewModel
/// - SwiftData 엔티티(IngredientEntity) CRUD를 담당
class MenuViewModel: ObservableObject {
    //    @Environment(\.modelContext) private var context
    
    /// SwiftData에 저장된 모든 IngredientEntity를 최신순(createdAt)으로 가져옴
    @Published var allIngredients: [IngredientEntity] = []
    private var context: ModelContext?
    
    static var empty: MenuViewModel {
        MenuViewModel()
    }

    init(context: ModelContext? = nil) {
        self.context = context
        fetchAllIngredients()
    }
    
    func setContextIfNeeded(_ newContext: ModelContext) {
        if context == nil {
            context = newContext
            fetchAllIngredients()
        }
    }
    
    /*
     @Environment(\.modelContext)는 View 내부에서만 안전하게 접근 가능한 프로퍼티입니다.
     지금 fetchAllIngredients()는 아마 MenuViewModel 같은 ViewModel 클래스에서 호출 중일 것인데, 거기서 context.fetch(...)를 쓰면 이 오류가 발생합니다.
     
     ✅ SwiftUI의 @Environment(\.modelContext)는 View 내부에서만 업데이트/유효하며,
     ViewModel 클래스에서 사용하면 항상 **기본값(nil 또는 빈 컨텍스트)**를 반환합니다.
     */
    
    
    
    /// 전체 IngredientEntity fetch
    //    func fetchAllIngredients() {
    //        let descriptor = FetchDescriptor<IngredientEntity>(
    //            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
    //        )
    //        do {
    //            allIngredients = try context.fetch(descriptor)
    //        } catch {
    //            print("❌ fetchAllIngredients error:", error)
    //            allIngredients = []
    //        }
    //    }
    func fetchAllIngredients() {
        guard let context else {
            print("⚠️ ModelContext not set")
            return
        }
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
        guard let context else {
                    print("⚠️ ModelContext not set")
                    return []
                }
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
        guard let context else {
            print("⚠️ ModelContext not set")
            return
        }
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
            print("✅ 저장 완료. 현재 총 메뉴 수: \(allIngredients.count)")
            allIngredients.forEach { ing in
                print("• 메뉴명: \(ing.menuName), 가격: \(ing.menuPrice)")
            }
            fetchAllIngredients()
        } catch {
            print("❌ saveIngredients error:", error)
        }
    }
}
