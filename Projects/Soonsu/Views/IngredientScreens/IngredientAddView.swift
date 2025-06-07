//
//  SSAddIngredientView.swift
//  Soonsu
//
//  Created by JiJooMaeng on 6/2/25.
//


//
//  SSAddIngredientView.swift
//  Sooik
//
//  Created by ellllly on 5/30/25.
//
 
import SwiftUI
import SwiftData
 
struct IngredientAddView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    // 검색창 텍스트
    @State private var searchText: String = ""
    
    // 콜백: 선택된 재료명을 부모 뷰로 전달
    var onSelect: (String) -> Void
    
    
    
    // MARK: - SwiftData에서 불러온 모든 고유 재료명
    private var allItems: [String] {
        let descriptor = FetchDescriptor<Ingredient>(
            predicate: nil,
            sortBy: [SortDescriptor(\.name, order: .forward)]
        )
        do {
            let entities = try context.fetch(descriptor)
            let names = entities.map(\.name)
            return Array(Set(names)).sorted()
        } catch {
            print("❌ Fetch error IngredientAddView:", error)
            return []
        }
    }
    
    // 검색 내용에 따른 필터 적용
    private var filteredItems: [String] {
        let trimmed = searchText.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty {
            return allItems
        } else {
            return allItems.filter {
                $0.localizedStandardContains(trimmed)
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(filteredItems, id: \.self) { item in
                Button(action: {
                    // 재료명을 선택하면 부모 뷰로 전달 후 뒤로 팝
                    onSelect(item)
                    dismiss()
                }) {
                    Text(item)
                }
            }
        }
        .navigationTitle("재료 추가")
        .searchable(text: $searchText, prompt: "검색어를 입력하세요")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("취소") {
                    onSelect("")  // 빈 문자열 전달 시 아무 동작 없이 뒤로 팝
                    dismiss()
                }
            }
        }
    }
}
