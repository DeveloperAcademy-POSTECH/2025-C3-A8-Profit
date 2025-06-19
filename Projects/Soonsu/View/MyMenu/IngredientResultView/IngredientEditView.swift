//
//  IngredientEditView.swift
//  Soonsu
//
//  Created by coulson on 6/19/25.
//

import SwiftUI
import SwiftData

struct IngredientEditView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss

    @Binding var selectedMenuName: String

    let menuName: String
    let menuPrice: String
    let image: UIImage?
    
    @State private var ingredients: [IngredientInfo]
    
    @State private var selectedIngredient: IngredientInfo? = nil
    @State private var showIngredientModifySheet = false
    @State private var navigateToSearch = false

    private var totalCost: Int {
        ingredients.reduce(0) { $0 + $1.unitPrice }
    }

    init(
        selectedMenuName: Binding<String>,
        menuName: String,
        menuPrice: String,
        image: UIImage?,
        parsedIngredients: [IngredientInfo]
    ) {
        self._selectedMenuName = selectedMenuName
        self.menuName = menuName
        self.menuPrice = menuPrice
        self.image = image
        self._ingredients = State(initialValue: parsedIngredients)
    }

    var body: some View {
        VStack(spacing: 0) {
            // 상단 헤더
            IngredientHeaderView(
                menuName: menuName,
                menuPrice: menuPrice,
                image: image
            )

            // 재료 리스트
            IngredientListView(
                ingredients: ingredients
            ) { selected in
//                DispatchQueue.main.async {
//                    selectedIngredient = selected
//                    showIngredientModifySheet = true
//                }
                selectedIngredient = selected
            }

            // 하단 푸터 (총 원가, 확인 버튼)
            IngredientResultFooterView(
                totalCost: totalCost,
                isNew: false,
                onPrimaryTapped: saveUpdatedIngredients,
                onAddTapped: {
                    navigateToSearch = true
                }
            )
        }
        .ignoresSafeArea(.keyboard)
        .navigationTitle("재료관리")
        .ingredientModifySheet(
//            isPresented: $showIngredientModifySheet,
//            ingredients: $ingredients,
//            selectedIngredient: $selectedIngredient
            selectedIngredient: $selectedIngredient,
            ingredients: $ingredients
        )
        .navigationDestination(isPresented: $navigateToSearch) {
            IngredientAddView(parsedIngredients: $ingredients) { selectedItemName in
                if !selectedItemName.isEmpty {
                    let newIng = IngredientInfo(
                        name: selectedItemName,
                        amount: "0g",
                        unitPrice: 0
                    )
                    ingredients.append(newIng)
                }
            }
        }
    }

    // 기존 재료 삭제 후 새로 저장
    private func saveUpdatedIngredients() {
        let fetchDescriptor = FetchDescriptor<Ingredient>(
            predicate: #Predicate { $0.menuName == menuName }
        )

        do {
            // 1️⃣ 기존 재료 삭제
            let existing = try context.fetch(fetchDescriptor)
            for item in existing {
                context.delete(item)
            }

            // 2️⃣ 새 재료 insert
            let priceValue = Int(menuPrice) ?? 0
            let imageData = image?.jpegData(compressionQuality: 0.8)

            for info in ingredients {
                let newItem = Ingredient(
                    menuName: menuName,
                    menuPrice: priceValue,
                    imageData: imageData,
                    info: info
                )
                context.insert(newItem)
            }

            // 3️⃣ 저장 후 MyMenuView 갱신 유도
            try context.save()
            selectedMenuName = "\(menuName)-\(UUID().uuidString)"

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                dismiss()
            }

            print("✅ 수정 저장 완료")

        } catch {
            print("❌ 수정 저장 실패: \(error)")
        }
    }
}
