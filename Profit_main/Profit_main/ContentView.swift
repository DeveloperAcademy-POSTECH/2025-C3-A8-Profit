//
//  ContentView.swift
//  Profit_main
//
//  Created by Mumin on 5/28/25.
//

import SwiftUI

// MARK: - 메인 화면 뷰
/// 메뉴 관리 앱의 메인 화면을 담당하는 뷰
struct ContentView: View {
    // MARK: - State Properties
    @State private var isPlusButtonPressed = false    // + 버튼 눌림 상태
    @State private var selectedTab = 1                // 현재 선택된 탭 (1: 메뉴관리)
    @State private var showingAddMenu = false         // 메뉴 추가 모달 표시 상태
    @State private var menuItems: [MenuItem] = [      // 메뉴 아이템 리스트
        MenuItem(name: "함박스테이크", cost: 5300, profitMargin: 30)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 네비게이션 바
            navigationBar
            
            // 메인 컨텐츠 영역
            mainContentArea
            
            // 하단 탭바
            bottomTabBar
        }
        .background(Color.white)
        .ignoresSafeArea(.all, edges: .bottom)
        .sheet(isPresented: $showingAddMenu) {
            AddMenuView(menuItems: $menuItems)
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled(false)
        }
    }
}

// MARK: - ContentView Extensions
extension ContentView {
    
    /// 상단 네비게이션 바
    private var navigationBar: some View {
        HStack {
            Spacer()
            Text("메뉴관리")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.vertical, 16)
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color.gray.opacity(0.3)),
            alignment: .bottom
        )
    }
    
    /// 메인 컨텐츠 영역
    private var mainContentArea: some View {
        ZStack {
            Color.white
            
            VStack {
                // 상단 타이틀과 + 버튼
                headerSection
                
                // 메뉴 리스트 또는 빈 상태 메시지
                contentSection
            }
        }
    }
    
    /// 헤더 섹션 (타이틀과 + 버튼)
    private var headerSection: some View {
        HStack {
            Text("나의 메뉴")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
            
            // 메뉴 추가 버튼
            addMenuButton
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    /// 메뉴 추가 버튼 (+ 버튼)
    private var addMenuButton: some View {
        Button(action: {
            showingAddMenu = true
        }) {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.blue)
        }
        .scaleEffect(isPlusButtonPressed ? 0.8 : 1.0)
        .onTapGesture {
            // 버튼 눌림 애니메이션
            withAnimation(.easeInOut(duration: 0.1)) {
                isPlusButtonPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPlusButtonPressed = false
                }
            }
        }
    }
    
    /// 컨텐츠 섹션 (메뉴 리스트 또는 빈 상태)
    private var contentSection: some View {
        Group {
            if menuItems.isEmpty {
                // 메뉴가 없을 때 표시되는 안내 메시지
                emptyStateView
            } else {
                // 메뉴 리스트
                menuListView
            }
        }
    }
    
    /// 빈 상태 뷰 (메뉴가 없을 때)
    private var emptyStateView: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 8) {
                Text("메뉴를 추가해서 재료원가를")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                Text("파악해보세요")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
    
    /// 메뉴 리스트 뷰
    private var menuListView: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(menuItems, id: \.id) { menuItem in
                        MenuItemView(menuItem: menuItem, menuItems: $menuItems)
                        
                        // 구분선 (마지막 아이템 제외)
                        if menuItem.id != menuItems.last?.id {
                            dividerLine
                        }
                    }
                }
            }
            .padding(.top, 16)
            
            Spacer()
        }
    }
    
    /// 구분선
    private var dividerLine: some View {
        Rectangle()
            .frame(height: 0.5)
            .foregroundColor(Color.gray.opacity(0.3))
            .padding(.horizontal, 20)
    }
    
    /// 하단 탭바
    private var bottomTabBar: some View {
        HStack {
            TabBarButton(
                icon: "house",
                title: "홈",
                isSelected: selectedTab == 0,
                action: { selectedTab = 0 }
            )
            
            TabBarButton(
                icon: "doc.text",
                title: "메뉴관리",
                isSelected: selectedTab == 1,
                action: { selectedTab = 1 }
            )
            
            TabBarButton(
                icon: "calendar",
                title: "수익관리",
                isSelected: selectedTab == 2,
                action: { selectedTab = 2 }
            )
            
            TabBarButton(
                icon: "dollarsign.circle",
                title: "비용관리",
                isSelected: selectedTab == 3,
                action: { selectedTab = 3 }
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color.gray.opacity(0.3)),
            alignment: .top
        )
    }
}

// MARK: - 탭바 버튼 컴포넌트
/// 하단 탭바의 개별 버튼을 담당하는 재사용 가능한 컴포넌트
struct TabBarButton: View {
    // MARK: - Properties
    let icon: String           // SF Symbol 아이콘명
    let title: String          // 탭 제목
    let isSelected: Bool       // 선택 상태
    let action: () -> Void     // 탭 선택 시 실행할 액션
    
    @State private var isPressed = false  // 버튼 눌림 상태
    
    var body: some View {
        Button(action: {
            action() // 탭 변경 액션 실행
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .blue : .gray)
                
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(isSelected ? .blue : .gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .onTapGesture {
            // 버튼 눌림 애니메이션
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
            action() // 탭 변경 액션 실행
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
