//
//  TabBarView.swift
//  Soonsu
//
//  Created by coulson on 6/2/25.
//

import SwiftUI

/// 하단 탭 바 (각 탭별로 아이콘과 텍스트)
struct TabBarView: View {
    @Binding var selectedTab: TabType

    var body: some View {
        HStack {
            ForEach(TabType.allCases, id: \.self) { tab in
                VStack(spacing: 4) {
                    Image(systemName: tab.iconName)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(selectedTab == tab ? .blue : .gray)
                    Text(tab.rawValue)
                        .font(.caption)
                        .foregroundColor(selectedTab == tab ? .blue : .gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .onTapGesture {
                    selectedTab = tab
                    // 필요 시 탭 전환 로직을 구현
                }
            }
        }
        .background(Color.white.ignoresSafeArea(edges: .bottom))
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: -1)
    }
}

enum TabType: String, CaseIterable {
    case home   = "홈"
    case menu   = "메뉴관리"
    case profit = "수익관리"
    case cost   = "비용관리"
    
    var iconName: String {
        switch self {
        case .home:   return "house"
        case .menu:   return "list.bullet.rectangle"
        case .profit: return "calendar"
        case .cost:   return "banknote"
        }
    }
}


#Preview {
        TabBarView(selectedTab: .constant(.menu)).previewLayout(.sizeThatFits)
}
