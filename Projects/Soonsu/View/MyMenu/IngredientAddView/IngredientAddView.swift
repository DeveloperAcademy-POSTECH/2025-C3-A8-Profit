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
    @Binding var parsedIngredients: [IngredientInfo]
    var onIngredientSelected: ((String) -> Void)? = nil
    @Environment(\.dismiss) private var dismiss
    
    // 검색창 텍스트
    @State private var searchText: String = ""
    
    private let ingredients = loadAllIngredientsFromJSON()
    private var filteredItems: [IngredientInfo] {
        let trimmed = searchText.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty {
            return []
        } else {
            return ingredients.map(\.self).filter {
                $0.name.localizedStandardContains(trimmed)
            }
        }
    }
    
    var body: some View {
        
        List(filteredItems, id: \.name) { item in
            NavigationLink(
                destination:
                    IngredientDetailView(
                        ingredient: item,
                        ingredients: $parsedIngredients
                    )
            )
            {
                Text(item.name)
            }
            .onTapGesture {
                onIngredientSelected?(item.name)
                
            }
        }
        .navigationTitle("재료 추가")
        .searchable(text: $searchText, placement: .toolbar, prompt: "검색어를 입력하세요")
    }
}
//
//#Preview {
//    IngredientAddView()
//        .modelContainer(for: Ingredient.self)
//}

