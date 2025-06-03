//
//  ContentView.swift
//  HambJaeryoModal
//
//  Created by coulson on 5/28/25.
//

import SwiftUI
import SwiftData

struct MyMenuView: View {
    @State private var showAddMenu      = false
    @State private var selectedMenuName = ""
    
    // SwiftData에서 모든 IngredientEntity를 최신순(createdAt)으로 가져옴
    @Query(sort: \IngredientEntity.createdAt, order: .reverse)
    private var allIngredients: [IngredientEntity]
    
    @Environment(\.modelContext) private var context
    
    /// 중복 없이 최신순으로 정리한 메뉴 이름 배열
    private var menuNames: [String] {
        var seen: Set<String> = []
        return allIngredients.compactMap { entity in
            guard !seen.contains(entity.menuName) else { return nil }
            seen.insert(entity.menuName)
            return entity.menuName
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                if menuNames.isEmpty {
                    Spacer()
                    Text(
                        """
                        메뉴를 추가해서 재료원가를
                        파악해보세요
                        """
                    )
                    .font(.body)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
                    .padding()
                    Spacer()
                    
                } else {
                    List {
                        ForEach(menuNames, id: \.self) { name in
                            MenuRowView(menuName: name)
                                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                            
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.white)
                }
                
            }
            .padding(16)
            .navigationTitle("나의 메뉴")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    showAddMenu = true
                } label: {
                    Image(systemName: "plus")
                        .fontWeight(.bold)
                }
            }
            
            // ── “나의 메뉴 +” → IngredientSheetView ─────────
            .navigationDestination(isPresented: $showAddMenu) {
                MenuInputView(
                    showAddMenu:      $showAddMenu,
                    selectedMenuName: $selectedMenuName
                )
            }
        }

        // ── 디버그: allIngredients의 변화 감지
        .onChange(of: allIngredients.count) { _, newCount in
            print("🔵 [Debug] allIngredients.count changed to \(newCount)")
        }
        // ── 디버그: selectedMenuName이 바뀌면 showAddMenu를 false로 (IngredientSheetView를 강제 팝)
        .onChange(of: selectedMenuName) { _, newValue in
            if !newValue.isEmpty {
                // “메뉴 등록” 직후: 이 코드를 통해 showAddMenu가 false가 되어
                // IngredientSheetView + IngredientResultView가 모두 팝됩니다.
                showAddMenu = false
            }
        }
    }
}

#Preview {
    NavigationStack {
        MyMenuView()
            .modelContainer(for: [IngredientEntity.self], inMemory: true)
    }
}
