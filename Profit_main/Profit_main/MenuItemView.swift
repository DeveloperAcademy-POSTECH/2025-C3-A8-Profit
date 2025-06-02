//
//  MenuItemView.swift
//  Profit_main
//
//  Created by Mumin on 5/28/25.
//

import SwiftUI

// MARK: - 메뉴 아이템 데이터 모델
/// 메뉴의 기본 정보를 담는 구조체
struct MenuItem {
    let id = UUID()              // 고유 식별자
    let name: String             // 메뉴명
    let cost: Int                // 재료원가 (원)
    let profitMargin: Double     // 수익률 (%)
}

// MARK: - 메뉴 아이템 뷰 컴포넌트
/// 개별 메뉴 아이템을 표시하는 재사용 가능한 뷰 컴포넌트
struct MenuItemView: View {
    let menuItem: MenuItem
    @Binding var menuItems: [MenuItem]
    @State private var showingEditMenu = false
    
    var body: some View {
        Button(action: {
            showingEditMenu = true
        }) {
            HStack(spacing: 16) {
                // 메뉴 이미지 영역
                menuImagePlaceholder
                
                // 메뉴 정보 영역
                menuInfoSection
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.white)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingEditMenu) {
            EditMenuView(menuItems: $menuItems, menuItem: menuItem)
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled(false)
        }
    }
}

// MARK: - MenuItemView Extensions
extension MenuItemView {
    
    /// 메뉴 이미지 플레이스홀더
    private var menuImagePlaceholder: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.2))
            .frame(width: 60, height: 60)
            .overlay(
                Image(systemName: "photo")
                    .font(.system(size: 24))
                    .foregroundColor(.gray.opacity(0.6))
            )
    }
    
    /// 메뉴 정보 섹션 (메뉴명, 재료원가, 수익률)
    private var menuInfoSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            // 메뉴명과 화살표
            menuNameRow
            
            // 재료원가 정보
            costInfoRow
            
            // 수익률 프로그레스 바
            profitMarginRow
        }
    }
    
    /// 메뉴명과 우측 화살표 아이콘
    private var menuNameRow: some View {
        HStack {
            Text(menuItem.name)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.gray.opacity(0.6))
        }
    }
    
    /// 재료원가 정보 표시
    private var costInfoRow: some View {
        HStack {
            Text("재료원가 \(menuItem.cost.formatted())원")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Spacer()
        }
    }
    
    /// 수익률을 프로그레스 바와 퍼센트로 표시
    private var profitMarginRow: some View {
        HStack {
            ProgressView(value: menuItem.profitMargin / 100.0)
                .progressViewStyle(LinearProgressViewStyle(tint: .gray))
                .frame(height: 4)
            
            Text("\(Int(menuItem.profitMargin))%")
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .frame(width: 30, alignment: .trailing)
        }
    }
}

// MARK: - Preview
#Preview {
    MenuItemView(menuItem: MenuItem(
        name: "함박스테이크",
        cost: 5300,
        profitMargin: 30
    ), menuItems: .constant([MenuItem(
        name: "함박스테이크",
        cost: 5300,
        profitMargin: 30
    )]))
} 