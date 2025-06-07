//
//  OverheadCostManageView.swift
//  Soonsu
//
//  Created by JiJooMaeng on 6/6/25.
//

import SwiftUI

struct OverheadCostManageView: View {
    @State private var selectedItem: String = "+ 간접비 추가"
    @State private var selectedItems: [String] = []
    let options = ["임차료", "공과금", "인터넷/통신비", "렌탈료", "보험료", "소모품비", "광고선전비", "이자비용", "카드결제수수료", "기타/잡비"]
    
var body: some View {
    ScrollView {
        VStack(spacing: 24) {
            HStack {
                Text("간접비")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                
                Menu {
                    ForEach(options, id: \.self) { item in
                        Button {
                            if !selectedItems.contains(item) {
                                selectedItems.append(item)
                            }
                        } label: {
                            Text(item)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedItem)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, lineWidth: 1)
                    )
                }
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(selectedItems, id: \.self) { item in
                    VStack(spacing: 8) {
                        Image(systemName: iconName(for: item))
                            .font(.largeTitle)
                        Text(item)
                            .fontWeight(.semibold)
                        Text("0 원")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                }
            }
            
            VStack {
                HStack {
                    Text("월 간접비")
                        .fontWeight(.semibold)
                    Spacer()
                    Text("0원")
                        .fontWeight(.bold)
                }
                .padding(.vertical, 8)

                Button("간접비 등록") {}
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.gray.opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding(16)
        .navigationTitle(Text("간접비 관리"))
        .navigationBarTitleDisplayMode(.inline)
    }
    }
    
    private func iconName(for item: String) -> String {
        switch item {
        case "임차료": return "house.fill"
        case "공과금": return "bolt.fill"
        case "인터넷/통신비": return "dot.radiowaves.left.and.right"
        default: return "info.circle"
        }
    }
}

#Preview {
    NavigationStack {
        OverheadCostManageView()
    }
}
