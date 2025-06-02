//
//  EditMenuView.swift
//  Profit_main
//
//  Created by Mumin on 5/28/25.
//

import SwiftUI

// MARK: - 재료 아이템 데이터 모델
/// 개별 재료의 정보를 담는 구조체
struct Ingredient {
    let id = UUID()
    let name: String
    let amount: String
    let cost: Int
    let icon: String
}

// MARK: - 메뉴 수정 뷰
/// 기존 메뉴를 수정하기 위한 모달 시트 뷰
struct EditMenuView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @Binding var menuItems: [MenuItem]
    let menuItem: MenuItem
    
    // MARK: - State Properties
    @State private var menuName: String
    @State private var menuPrice: String
    @State private var isGramUnit: Bool = true          // 그램 단위 토글
    @State private var isEditMode: Bool = false         // 편집 모드 상태
    @State private var selectedIngredients: Set<UUID> = [] // 선택된 재료들
    @State private var ingredients: [Ingredient] = [    // 재료 리스트
        Ingredient(name: "양배추", amount: "40g", cost: 400, icon: "🥬"),
        Ingredient(name: "양배추", amount: "40g", cost: 400, icon: "🥬"),
        Ingredient(name: "양배추", amount: "40g", cost: 400, icon: "🥬"),
        Ingredient(name: "양배추", amount: "40g", cost: 400, icon: "🥬"),
        Ingredient(name: "양배추", amount: "40g", cost: 400, icon: "🥬"),
        Ingredient(name: "양배추", amount: "40g", cost: 400, icon: "🥬"),
        Ingredient(name: "양배추", amount: "40g", cost: 400, icon: "🥬")
    ]
    
    // 초기화
    init(menuItems: Binding<[MenuItem]>, menuItem: MenuItem) {
        self._menuItems = menuItems
        self.menuItem = menuItem
        self._menuName = State(initialValue: menuItem.name)
        self._menuPrice = State(initialValue: "\(Int(Double(menuItem.cost) / 0.7))원") // 역계산
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 상단 네비게이션
                navigationHeader
                
                // 메인 컨텐츠
                mainContent
            }
            .background(Color(UIColor.systemGray6))
        }
    }
}

// MARK: - EditMenuView Extensions
extension EditMenuView {
    
    /// 상단 네비게이션 헤더
    private var navigationHeader: some View {
        HStack {
            Spacer()
            
            Button(isEditMode ? "완료" : "편집") {
                withAnimation {
                    isEditMode.toggle()
                    if !isEditMode {
                        selectedIngredients.removeAll()
                    }
                }
            }
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(.blue)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
    }
    
    /// 메인 컨텐츠 영역
    private var mainContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 메뉴 정보 섹션
                menuInfoSection
                
                // 재료 리스트 섹션
                ingredientsSection
                
                // 재료 추가/삭제 버튼
                addIngredientButton
                
                // 재료원가 표시
                totalCostSection
                
                // 하단 버튼
                registerButton
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
    }
    
    /// 메뉴 정보 섹션
    private var menuInfoSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                // 메뉴 이미지
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 24))
                            .foregroundColor(.gray.opacity(0.6))
                    )
                
                // 메뉴 정보
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        if isEditMode {
                            TextField("메뉴명", text: $menuName)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.blue)
                        } else {
                            Text(menuName)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                        }
                        
                        if isEditMode {
                            TextField("가격", text: $menuPrice)
                                .font(.system(size: 16))
                                .foregroundColor(.blue)
                        } else {
                            Text(menuPrice)
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // 그램 단위 토글
                    HStack {
                        Spacer()
                        
                        HStack(spacing: 8) {
                            Text("그램 단위")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            Toggle("", isOn: $isGramUnit)
                                .labelsHidden()
                        }
                    }
                }
                
                Spacer()
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    /// 재료 리스트 섹션
    private var ingredientsSection: some View {
        VStack(spacing: 0) {
            ForEach(Array(ingredients.enumerated()), id: \.element.id) { index, ingredient in
                ingredientRow(ingredient: ingredient)
                
                // 구분선 (마지막 아이템 제외)
                if index < ingredients.count - 1 {
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(Color.gray.opacity(0.3))
                        .padding(.horizontal, 16)
                }
            }
        }
        .background(Color.white)
        .cornerRadius(12)
    }
    
    /// 개별 재료 행
    private func ingredientRow(ingredient: Ingredient) -> some View {
        HStack(spacing: 16) {
            // 편집 모드일 때 체크박스 표시
            if isEditMode {
                Button(action: {
                    if selectedIngredients.contains(ingredient.id) {
                        selectedIngredients.remove(ingredient.id)
                    } else {
                        selectedIngredients.insert(ingredient.id)
                    }
                }) {
                    Circle()
                        .stroke(Color.gray, lineWidth: 1)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Circle()
                                .fill(selectedIngredients.contains(ingredient.id) ? Color.blue : Color.clear)
                                .frame(width: 16, height: 16)
                        )
                }
            }
            
            // 재료 아이콘
            Circle()
                .fill(Color.green.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(ingredient.icon)
                        .font(.system(size: 20))
                )
            
            // 재료 정보
            VStack(alignment: .leading, spacing: 2) {
                Text(ingredient.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            // 수량과 가격
            VStack(alignment: .trailing, spacing: 2) {
                Text(ingredient.amount)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                
                Text("\(ingredient.cost)원")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            // 화살표 (편집 모드가 아닐 때만 표시)
            if !isEditMode {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.gray.opacity(0.6))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    /// 재료 추가/삭제 버튼
    private var addIngredientButton: some View {
        Button(action: {
            if isEditMode {
                // 선택된 재료들 삭제
                ingredients.removeAll { selectedIngredients.contains($0.id) }
                selectedIngredients.removeAll()
            } else {
                // TODO: 재료 추가 기능
            }
        }) {
            HStack {
                Text(isEditMode ? "재료 삭제하기" : "재료 추가하기")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isEditMode ? .red : .blue)
                
                if !isEditMode {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.blue)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        }
        .disabled(isEditMode && selectedIngredients.isEmpty)
    }
    
    /// 총 재료원가 섹션
    private var totalCostSection: some View {
        VStack(spacing: 16) {
            Text("재료원가는 \(calculateTotalCost().formatted())원입니다")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
        }
        .padding(.top, 20)
    }
    
    /// 메뉴 등록 버튼
    private var registerButton: some View {
        Button(action: {
            updateMenu()
        }) {
            Text(isEditMode ? "메뉴 등록" : "메뉴 등록")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.gray)
                .cornerRadius(8)
        }
        .padding(.bottom, 34)
    }
    
    /// 총 재료원가 계산
    private func calculateTotalCost() -> Int {
        return ingredients.reduce(0) { $0 + $1.cost }
    }
    
    /// 메뉴 업데이트 함수
    private func updateMenu() {
        if let index = menuItems.firstIndex(where: { $0.id == menuItem.id }) {
            let updatedMenuItem = MenuItem(
                name: menuName,
                cost: calculateTotalCost(),
                profitMargin: 30.0 // 임시 수익률
            )
            menuItems[index] = updatedMenuItem
        }
        dismiss()
    }
}

// MARK: - Preview
#Preview {
    EditMenuView(
        menuItems: .constant([]),
        menuItem: MenuItem(name: "함박스테이크", cost: 5300, profitMargin: 30)
    )
} 