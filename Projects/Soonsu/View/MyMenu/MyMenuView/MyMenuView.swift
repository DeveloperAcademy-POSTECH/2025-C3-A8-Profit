//
//  ContentView.swift
//  HambJaeryoModal
//
//  Created by coulson on 5/28/25.
//

import SwiftUI
import SwiftData

struct MyMenuView: View {
    
    @Environment(\.modelContext) private var context
    @ObservedObject var viewModel: MenuViewModel
    
    
    @State private var showAddMenu      = false
    @State private var selectedMenuName = ""
    
    
    // 선택된 메뉴 데이터
    @State private var navigationTarget: IngredientNavigationData? = nil
    
    
//    @StateObject private var navState = NavigationState()
    
//    init(viewModel: MenuViewModel) {
//        self.viewModel = viewModel
//        self._showAddMenu = State(initialValue: false)
//        self._selectedMenuName = State(initialValue: "")
//    }
    
    private var allIngredients: [Ingredient]{
        viewModel.allIngredients
    }
    
    /// 중복 없이 최신순으로 정리한 메뉴 이름 배열
    private var menuNames: [String] {
        var seen: Set<String> = []
//        return viewModel.allIngredients.compactMap { entity in
//            guard !seen.contains(entity.menuName) else { return nil }
//            seen.insert(entity.menuName)
//            return entity.menuName
//        }
        return allIngredients.compactMap {
                    guard !seen.contains($0.menuName) else { return nil }
                    seen.insert($0.menuName)
                    return $0.menuName
                }.sorted(by: >)
    }
    
    var body: some View {
//        let menuNames = Set(viewModel.allIngredients.map(\.menuName)).sorted(by: >)
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
                            MenuRowView(menuName: name) {
                                // 클릭 시 필요한 데이터 수집
                                let matched = allIngredients.filter { $0.menuName == name }
                                guard let header = matched.first else { return }
                                let infoList = matched.map {
                                    IngredientInfo(name: $0.name, amount: $0.amount, unitPrice: $0.unitPrice)
                                }
                                navigationTarget = IngredientNavigationData(
                                    menuName: name,
                                    menuPrice: String(header.menuPrice),
                                    image: header.imageData.flatMap { UIImage(data: $0) },
                                    ingredients: infoList
                                )
                            }
                                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                            
                        }
                        .onDelete(perform: deleteMenus)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.white)
                }
                
            }
            .padding(16)
            .navigationTitle("나의 메뉴")
//            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {    //
                    Button {
                        showAddMenu = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.primaryColor700)
                            .fontWeight(.bold)
                    }
                }
            }   //
//            .navigationDestination(for: String.self) { value in
//                switch value {
//                case "MenuInputView":
//                    MenuInputView(
//                        showAddMenu:      $showAddMenu,
//                        selectedMenuName: $selectedMenuName
//                    )
//                default:
//                    EmptyView()
//                }
//            }
            
            // ── “나의 메뉴 +” → IngredientSheetView ─────────
            .navigationDestination(isPresented: $showAddMenu) {
                MenuInputView(
                    showAddMenu:      $showAddMenu,
                    selectedMenuName: $selectedMenuName
                )
            }
            
            
            // 상세 재료 정보 화면으로 이동
                        .navigationDestination(item: $navigationTarget) { data in
                            IngredientResultView(
                                isNew: false,
                                selectedMenuName: .constant(data.menuName),
                                showAddMenu:      .constant(false),
                                menuName:         data.menuName,
                                menuPrice:        data.menuPrice,
                                image:            data.image,
                                parsedIngredients: data.ingredients
                            )
                        }
        }
//        .environmentObject(navState)

        .onChange(of: selectedMenuName) { _, newValue in
            if !newValue.isEmpty {
                showAddMenu = false
                viewModel.fetchAllIngredients() // 새로 등록한 메뉴 반영
            }
        }
        
        .onChange(of: allIngredients.map { "\($0.menuName)-\($0.menuPrice)-\($0.id)" }) { _, _ in
            viewModel.fetchAllIngredients()
        }
        
        
        // ── 디버그: allIngredients의 변화 감지
        .onChange(of: allIngredients.count) { _, newCount in
            print("🔵 [Debug] allIngredients.count changed to \(newCount)")
        }
        
        
        // ── 디버그: selectedMenuName이 바뀌면 showAddMenu를 false로 (IngredientSheetView를 강제 팝)
//        .onChange(of: selectedMenuName) { _, newValue in
//            if !newValue.isEmpty {
//                // “메뉴 등록” 직후: 이 코드를 통해 showAddMenu가 false가 되어
//                // IngredientSheetView + IngredientResultView가 모두 팝됩니다.
//                showAddMenu = false
//            }
//        }
    }
    
    private func deleteMenus(at offsets: IndexSet) {
        for index in offsets {
            let name = menuNames[index]
            let matchingItems = allIngredients.filter { $0.menuName == name }
            for item in matchingItems {
                context.delete(item)
            }
        }
        do {
            try context.save()
        } catch {
            print("❌ 삭제 실패: \(error)")
        }
    }
}

// 메뉴 상세화면으로 네비게이션하기 위한 구조체
struct IngredientNavigationData: Identifiable, Hashable {
    var id: String { menuName } // 메뉴명 기준으로 구분
    let menuName: String
    let menuPrice: String
    let image: UIImage?
    let ingredients: [IngredientInfo]
}
