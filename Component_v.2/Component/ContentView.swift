//
//  ContentView.swift
//  Component
//
//  메뉴 관리 및 재료 원가 계산을 위한 메인 화면
//  Created by Mumin on 5/31/25.
//

import SwiftUI

// MARK: - Data Models

/// 재료 정보를 담는 데이터 모델
struct Ingredient {
    let id = UUID()
    let name: String        // 재료명
    let emoji: String       // 아이콘 이모지
    let weight: Int         // 중량 (그램)
    let price: Int          // 가격 (원)
}

/// 메뉴 아이템 정보를 담는 데이터 모델
struct MenuItem {
    let name: String        // 메뉴명
    let price: Int          // 판매가격 (원)
    let imageName: String   // 이미지 이름
}

// MARK: - Main View

/**
 * 메뉴 관리 메인 화면
 * 
 * 기능:
 * - 메뉴 정보 표시 (이름, 가격)
 * - 재료 목록 관리 (이름, 이모지, 중량, 가격)
 * - 재료 원가 총합 계산
 * - 원가율 분석 팝업 표시
 * - 메뉴 등록 및 목록 화면 이동
 */
struct ContentView: View {
    // MARK: - State Properties
    
    @State private var isGramUnit = true                    // 그램 단위 토글 상태
    @State private var showingCostAnalysis = false         // 원가 분석 팝업 표시 여부
    @State private var navigateToMyMenu = false            // 메뉴 목록 화면 이동 여부
    
    /// 재료 목록 (기본 함박스테이크 재료들)
    @State private var ingredients = [
        Ingredient(name: "돼지고기", emoji: "🥩", weight: 150, price: 3500),
        Ingredient(name: "계란", emoji: "🥚", weight: 50, price: 400),
        Ingredient(name: "양배추", emoji: "🥬", weight: 30, price: 500),
        Ingredient(name: "옥수수", emoji: "🌽", weight: 20, price: 200),
        Ingredient(name: "대파", emoji: "🥬", weight: 20, price: 100),
        Ingredient(name: "숙주나물", emoji: "🌱", weight: 20, price: 200)
    ]
    
    // MARK: - Constants
    
    /// 현재 관리 중인 메뉴 아이템
    private let menuItem = MenuItem(
        name: "함박스테이크",
        price: 14900,
        imageName: "hamburger.steak"
    )
    
    // MARK: - Computed Properties
    
    /// 재료 원가 총합 계산
    private var totalIngredientCost: Int {
        ingredients.reduce(0) { $0 + $1.price }
    }
    
    /// 재료 원가 비율 계산
    /// 공식: (재료원가 총합 ÷ 메뉴가격) × 100
    /// 원형 그래프에서 전체 원은 메뉴가격(100%), 색칠된 부분은 재료원가 비율을 나타냄
    private var costPercentage: Double {
        return Double(totalIngredientCost) / Double(menuItem.price) * 100
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 메인 화면
                mainContentView
                    .blur(radius: showingCostAnalysis ? 3 : 0)
                    .animation(.easeInOut(duration: 0.3), value: showingCostAnalysis)
                
                // 원가 분석 팝업 오버레이
                if showingCostAnalysis {
                    costAnalysisOverlay
                }
            }
            .navigationDestination(isPresented: $navigateToMyMenu) {
                MyMenuView()
            }
        }
    }
}

// MARK: - View Components

extension ContentView {
    
    /// 메인 콘텐츠 뷰
    private var mainContentView: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 상단 헤더
                headerSection
                
                // 스크롤 가능한 콘텐츠
                scrollableContent
                
                // 하단 고정 영역 (원가 표시 및 등록 버튼)
                bottomFixedSection
            }
        }
        .navigationBarHidden(true)
    }
    
    /// 상단 헤더 섹션
    private var headerSection: some View {
        HStack {
            Text("메뉴관리")
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    /// 스크롤 가능한 콘텐츠 영역
    private var scrollableContent: some View {
        ScrollView {
            VStack(spacing: 0) {
                // 메뉴 정보 카드
                menuInfoCard
                
                // 재료 목록
                ingredientsList
                
                // 재료 추가 버튼
                addIngredientButton
                
                Spacer(minLength: 100)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    /// 메뉴 정보 카드
    private var menuInfoCard: some View {
        HStack(spacing: 15) {
            // 메뉴 이미지 플레이스홀더
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                )
            
            // 메뉴 정보
            VStack(alignment: .leading, spacing: 4) {
                Text(menuItem.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("\(menuItem.price.formatted())원")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
            }
            
            Spacer()
            
            // 그램 단위 토글
            gramUnitToggle
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(Color.white)
    }
    
    /// 그램 단위 토글 컨트롤
    private var gramUnitToggle: some View {
        VStack {
            Text("그램 단위")
                .font(.caption)
                .foregroundColor(.gray)
            
            Toggle("", isOn: $isGramUnit)
                .labelsHidden()
        }
    }
    
    /// 재료 목록
    private var ingredientsList: some View {
        VStack(spacing: 0) {
            ForEach(ingredients, id: \.id) { ingredient in
                IngredientRow(ingredient: ingredient)
                
                // 마지막 아이템이 아닌 경우 구분선 추가
                if ingredient.id != ingredients.last?.id {
                    Divider()
                        .padding(.leading, 60)
                }
            }
        }
        .background(Color.white)
    }
    
    /// 재료 추가 버튼
    private var addIngredientButton: some View {
        Button(action: {
            // TODO: 재료 추가 기능 구현
            print("재료 추가하기 버튼 탭됨")
        }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
                Text("재료 추가하기")
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
            }
            .padding(.vertical, 15)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
    
    /// 하단 고정 영역 (원가 표시 및 등록 버튼)
    private var bottomFixedSection: some View {
        VStack(spacing: 15) {
            // 총 재료원가 표시
            Text("재료원가는 \(totalIngredientCost.formatted())원입니다")
                .font(.headline)
                .foregroundColor(.blue)
                .padding(.top, 15)
            
            // 메뉴 등록 버튼
            Button(action: {
                showingCostAnalysis = true
            }) {
                Text("메뉴 등록")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color.white)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -2)
    }
    
    /// 원가 분석 팝업 오버레이
    private var costAnalysisOverlay: some View {
        ZStack {
            // 반투명 배경
            Color.black.opacity(0.2)
                .ignoresSafeArea()
                .onTapGesture {
                    showingCostAnalysis = false
                }
            
            // 중앙 정렬된 원가 분석 팝업
            VStack {
                Spacer()
                
                CircularProgressView(
                    percentage: costPercentage,
                    menuName: menuItem.name,
                    onComplete: {
                        showingCostAnalysis = false
                        navigateToMyMenu = true
                    }
                )
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .transition(.scale.combined(with: .opacity))
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showingCostAnalysis)
        }
    }
}

// MARK: - Supporting Views

/**
 * 재료 행 컴포넌트
 * 개별 재료의 정보(이모지, 이름, 중량, 가격)를 표시
 */
struct IngredientRow: View {
    let ingredient: Ingredient
    
    var body: some View {
        HStack(spacing: 15) {
            // 재료 아이콘 (이모지)
            Text(ingredient.emoji)
                .font(.system(size: 24))
                .frame(width: 30, height: 30)
            
            // 재료 이름
            Text(ingredient.name)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // 중량 표시
            Text("\(ingredient.weight)g")
                .font(.body)
                .foregroundColor(.primary)
                .frame(width: 50, alignment: .trailing)
            
            // 가격과 화살표
            HStack(spacing: 5) {
                Text("\(ingredient.price.formatted())원")
                    .font(.body)
                    .foregroundColor(.gray)
                
                Image(systemName: "chevron.up")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(width: 80, alignment: .trailing)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .contentShape(Rectangle())  // 전체 영역 터치 가능하게 설정
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
