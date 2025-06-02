//
//  MyMenuView.swift
//  Component
//
//  등록된 메뉴 목록을 관리하고 표시하는 화면
//  Created by Mumin on 5/31/25.
//

import SwiftUI

// MARK: - 데이터 모델

/// 메뉴 아이템 정보와 원가율 계산을 담당하는 데이터 모델
struct MyMenuItem {
    let id = UUID()
    let name: String            // 메뉴명
    let ingredientCost: Int     // 재료원가 (원)
    let menuPrice: Int          // 메뉴가격 (원)
    
    /// 원가율 자동 계산 (재료원가/메뉴가격 * 100)
    var costRate: Int {
        guard menuPrice > 0 else { return 0 }
        return Int(round(Double(ingredientCost) / Double(menuPrice) * 100))
    }
}

// MARK: - 메인 화면

/// 나의 메뉴 목록 화면 - 등록된 메뉴들과 원가율을 표시
struct MyMenuView: View {
    
    /// 등록된 메뉴 목록 (샘플 데이터)
    @State private var menuItems: [MyMenuItem] = [
        MyMenuItem(
            name: "함박스테이크",
            ingredientCost: 5300,
            menuPrice: 16500    // 원가율: 32%
        )
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                headerSection
                menuListSection
                Spacer()
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
        .navigationBarHidden(true)
    }
}

// MARK: - 화면 구성 요소

extension MyMenuView {
    
    /// 상단 헤더 (제목 + 메뉴 추가 버튼)
    private var headerSection: some View {
        HStack {
            Text("나의 메뉴")
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            Button(action: addNewMenu) {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
    }
    
    /// 메뉴 목록 스크롤 영역
    private var menuListSection: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(menuItems, id: \.id) { item in
                    MyMenuItemRow(item: item)
                    
                    if !isLastItem(item) {
                        Divider().padding(.leading, 80)
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal, 20)
        }
    }
    
    /// 메뉴 추가 액션
    private func addNewMenu() {
        print("메뉴 추가 버튼 탭됨")
    }
    
    /// 마지막 아이템 여부 확인
    private func isLastItem(_ item: MyMenuItem) -> Bool {
        item.id == menuItems.last?.id
    }
}

// MARK: - 메뉴 아이템 행

/// 개별 메뉴 정보를 표시하는 행 컴포넌트
struct MyMenuItemRow: View {
    let item: MyMenuItem
    
    var body: some View {
        HStack(spacing: 15) {
            menuImagePlaceholder
            menuInfoSection
            Spacer()
            chevronIcon
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

extension MyMenuItemRow {
    
    /// 메뉴 이미지 플레이스홀더
    private var menuImagePlaceholder: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.3))
            .frame(width: 50, height: 50)
            .overlay(
                Image(systemName: "fork.knife.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.orange)
            )
    }
    
    /// 메뉴 정보 (이름, 가격, 원가율 바게이지)
    private var menuInfoSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.name)
                .font(.body)
                .fontWeight(.medium)
            
            priceInfoSection
            
            CostRateProgressComponent(
                costRate: item.costRate,
                menuName: item.name
            )
        }
    }
    
    /// 가격 정보 (메뉴가격 + 재료원가)
    private var priceInfoSection: some View {
        HStack(spacing: 8) {
            Text("메뉴가격 \(item.menuPrice.formatted())원")
                .font(.caption)
                .foregroundColor(.black)
            
            Text("• 재료원가 \(item.ingredientCost.formatted())원")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
    
    /// 상세보기 화살표
    private var chevronIcon: some View {
        Image(systemName: "chevron.right")
            .font(.caption)
            .foregroundColor(.gray)
    }
}

// MARK: - 프리뷰

#Preview {
    NavigationStack {
        MyMenuView()
    }
} 