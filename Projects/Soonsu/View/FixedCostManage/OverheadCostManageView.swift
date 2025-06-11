//
//  OverheadCostManageView.swift
//  Soonsu
//
//  Created by JiJooMaeng on 6/6/25.
//

import SwiftUI

struct OverheadCostManageView: View {
    @State private var selectedItem: String = "+ 간접비 추가"
    let options = ["임차료", "공과금", "인터넷/통신비", "보험료", "소모품비", "광고선전비", "감가상각비", "수도광열비", "렌탈료", "이자비용", "기타/잡비"]
    
    @State private var tempCosts: [(OverheadCost, BasicCost)] = []
    @State private var initializedDefaults = false
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
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
                            .fontWeight(.regular)
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
                            .stroke(Color.white, lineWidth: 1)
                    )
                }
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(tempCosts, id: \.0.id) { (overhead, basic) in
                    ZStack(alignment: .topLeading) {
                        NavigationLink(destination: OverheadBasicView(category: overhead.category, tempCosts: $tempCosts)) {
                            VStack(spacing: 8) {
                                Image(systemName: iconName(for: overhead.category.rawValue))
                                    .foregroundStyle(.black)
                                    .font(.largeTitle)
                                Text(overhead.category.rawValue)
                                    .foregroundStyle(.black)
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
                    // 저장만 하고 리스트는 유지
                }
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.blue)
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
        .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.blue)
                        }
                    }
                }
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
        case "공과금": return "folder.fill"
        case "인터넷/통신비": return "antenna.radiowaves.left.and.right"
        case "보험료": return "shield.pattern.checkered"
        case "소모품비": return "archivebox.circle.fill"
        case "광고선전비": return "megaphone.fill"
        case "감가상각비": return "clock.arrow.trianglehead.counterclockwise.rotate.90"
        case "수도광열비": return "bolt.fill"
        case "렌탈료": return "tray.circle.fill"
        case "이자비용": return "banknote.fill"
        case "기타/잡비": return "tag.fill"
        default: return "info.circle"
        }
    }
    
    private func category(from item: String) -> OverheadCategory? {
        switch item {
        case "임차료": return .rent
        case "공과금": return .tax
        case "인터넷/통신비": return .internet
        case "보험료": return .insurance
        case "소모품비": return .supply
        case "광고선전비": return .advertising
        case "감가상각비": return .depreciation
        case "수도광열비": return .utilities
        case "렌탈료": return .rental
        case "이자비용": return .interest
        case "기타/잡비": return .etc
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
