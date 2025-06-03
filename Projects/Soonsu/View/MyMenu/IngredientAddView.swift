//
//  SSAddIngredientView.swift
//  Sooik
//
//  Created by ellllly on 5/30/25.
//
 
import SwiftUI
import SwiftData
 
private let ingredients =

[
  "소금", "설탕", "간장", "된장", "고추장",
  "참기름", "식용유", "후추", "다진 마늘", "생강",
  "대파", "양파", "마늘", "청양고추", "고춧가루",
  "진간장", "국간장", "맛술", "식초", "미림",
  "쌀", "달걀", "돼지고기", "소고기", "닭고기",
  "두부", "김치", "감자", "당근", "애호박",
  "버섯", "배추", "무", "콩나물", "숙주",
  "멸치", "다시마", "건새우", "참치캔", "김",
  "깨", "올리고당", "물엿", "치즈", "우유",
  "빵가루", "전분", "밀가루", "쌀가루", "계피",
  "다진 소고기", "다진 돼지고기", "양송이버섯", "토마토소스", "데미글라스 소스","케첩", "머스타드", "파슬리", "버터", "올리브유",
  "넛맥", "로즈마리", "타임", "월계수잎", "샐러드 채소",
  "양배추", "오이", "토마토", "베이컨", "슬라이스 치즈",
  "모짜렐라 치즈", "파마산 치즈", "달걀물", "튀김가루", "중력분",
  "돈까스 소스", "우스터 소스", "브라운 소스", "생크림", "빵"
]


struct IngredientAddView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    // 검색창 텍스트
    @State private var searchText: String = ""
    
    // 콜백: 선택된 재료명을 부모 뷰로 전달
    var onSelect: (String) -> Void
    
    
    
    // MARK: - SwiftData에서 불러온 모든 고유 재료명
    private var allItems: [String] {
        let descriptor = FetchDescriptor<IngredientEntity>(
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
        NavigationStack {
            List {
                ForEach(ingredients.filter {
                    searchText.isEmpty ? true : $0.localizedStandardContains(searchText)
                }, id: \.self) { item in
                    Button(action: {
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
                        onSelect("")
                        dismiss()
                    }
                }
            }
        }
    }
    
//    var body: some View {
//        List {
////            ForEach(filteredItems, id: \.self) { item in
//            ForEach(ingredients, id: \.self) { item in
//                Button(action: {
//                    // 재료명을 선택하면 부모 뷰로 전달 후 뒤로 팝
//                    onSelect(item)
//                    dismiss()
//                }) {
//                    Text(item)
//                }
//            }
//        }
//        .navigationTitle("재료 추가")
//        .searchable(text: $searchText, prompt: "검색어를 입력하세요")
//        .toolbar {
//            ToolbarItem(placement: .cancellationAction) {
//                Button("취소") {
//                    onSelect("")  // 빈 문자열 전달 시 아무 동작 없이 뒤로 팝
//                    dismiss()
//                }
//            }
//        }
//    }
}
