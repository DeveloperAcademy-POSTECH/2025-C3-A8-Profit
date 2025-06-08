//
//  OverheadCostManageView.swift
//  Soonsu
//
//  Created by JiJooMaeng on 6/6/25.
//

import SwiftUI

struct OverheadCostManageView: View {
    @State private var selectedItem: String = "+ 간접비 추가"
    let options = ["임차료", "공과금", "인터넷/통신비", "렌탈료", "보험료", "소모품비", "광고선전비", "이자비용", "카드결제수수료", "기타/잡비"]
    
    @State private var tempCosts: [(OverheadCost, BasicCost)] = []
    @State private var initializedDefaults = false
    @Environment(\.modelContext) private var context
    @State private var isEditing = false
    @State private var selectedToDelete: Set<UUID> = []
    
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
                        if let category = category(from: item) {
                            Button {
                                let overhead = OverheadCost(category: category)
                                let basic = BasicCost(overheadCost: overhead, amount: 0)
                                tempCosts.append((overhead, basic))
                            } label: {
                                Text(item)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        } else {
                            Text(item)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.gray)
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
                ForEach(tempCosts, id: \.0.id) { (overhead, basic) in
                    ZStack(alignment: .topLeading) {
                        NavigationLink(destination: OverheadBasicView(category: overhead.category, tempCosts: $tempCosts)) {
                            VStack(spacing: 8) {
                                Image(systemName: iconName(for: overhead.category.rawValue))
                                    .font(.largeTitle)
                                Text(overhead.category.rawValue)
                                    .fontWeight(.semibold)
                                Text("\(basic.amount) 원")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                        if isEditing {
                            Button(action: {
                                if selectedToDelete.contains(overhead.id) {
                                    selectedToDelete.remove(overhead.id)
                                } else {
                                    selectedToDelete.insert(overhead.id)
                                }
                            }) {
                                Image(systemName: selectedToDelete.contains(overhead.id) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedToDelete.contains(overhead.id) ? .blue : .gray)
                                    .padding(6)
                            }
                        }
                    }
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

                Button("간접비 등록") {
                    for (overhead, basic) in tempCosts {
                        context.insert(overhead)
                        context.insert(basic)
                    }
                    tempCosts.removeAll()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.gray.opacity(0.5))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            Spacer()
        }
        .toolbar {
            if isEditing {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        isEditing = false
                        selectedToDelete.removeAll()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("삭제") {
                        tempCosts.removeAll { selectedToDelete.contains($0.0.id) }
                        selectedToDelete.removeAll()
                        isEditing = false
                    }
                    .foregroundColor(.red)
                }
            } else {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("편집") {
                        isEditing = true
                    }
                }
            }
        }
        .padding(16)
        .navigationTitle(Text("간접비 관리"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if !initializedDefaults {
                tempCosts = defaultTempCosts()
                initializedDefaults = true
            }
        }
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
    
    private func category(from item: String) -> OverheadCategory? {
        switch item {
        case "임차료": return .rent
        case "공과금": return .tax
        case "인터넷/통신비": return .internet
        case "렌탈료": return .rental
        case "보험료": return .insurance
        case "광고선전비": return .advertising
        case "이자비용": return .interest
        case "소모품비", "카드결제수수료", "기타/잡비": return .etc
        default: return nil
        }
    }
}

#Preview {
    NavigationStack {
        OverheadCostManageView()
    }
}

    private func defaultTempCosts() -> [(OverheadCost, BasicCost)] {
        let defaults: [OverheadCategory] = [.rent, .utilities, .internet]
        return defaults.map { category in
            let overhead = OverheadCost(category: category)
            let basic = BasicCost(overheadCost: overhead, amount: 0)
            return (overhead, basic)
        }
    }
