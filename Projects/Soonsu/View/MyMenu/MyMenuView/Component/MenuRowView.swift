//
//  MenuRowView.swift
//  HambJaeryoModal
//
//  Created by coulson on 5/28/25.
//

import SwiftUI
import SwiftData

struct MenuRowView: View {
    let menuName: String
    
    @Environment(\.modelContext) private var context
    @State private var showDetail = false
    
    /// 해당 메뉴명에 속한 IngredientEntity를 모두 가져오는 computed 프로퍼티
    private var matchedEntities: [Ingredient] {
        let predicate = #Predicate<Ingredient> { $0.menuName == menuName }
        let descriptor = FetchDescriptor<Ingredient>(
            predicate: predicate,
            sortBy:    [SortDescriptor(\.createdAt, order: .reverse)]
        )
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Fetch error for \(menuName):", error)
            return []
        }
    }
    
    /// 헤더용 엔티티(이미지·가격)로 사용할 첫 번째 항목
    private var headerEntity: Ingredient? {
        matchedEntities.first
    }
    
    /// 헤더 이미지(UIImage?) 준비
    private var headerImage: UIImage? {
        guard let data = headerEntity?.imageData else { return nil }
        return UIImage(data: data)
    }
    
    /// 헤더 가격(String) 준비
    private var priceString: String {
        headerEntity.map { String($0.menuPrice) } ?? ""
    }
    
    /// 재료 리스트용 IngredientInfo 배열
    private var infos: [IngredientInfo] {
        matchedEntities.map {
            IngredientInfo(
                name: $0.name,
                amount: $0.amount,
                //                unit: $0.unit,
                unitPrice: $0.unitPrice
            )
        }
    }
    
        /// 총 원가(Int)
        private var totalCost: Int {
            matchedEntities.reduce(0) { $0 + $1.unitPrice }
        }
    
    
        /// 원가율 (Double 백분율 값, 소수점 첫째자리까지)
        private var costRateString: String {
            guard let price = headerEntity?.menuPrice, price > 0 else { return "-" }
            let rate = (Double(totalCost) / Double(price)) * 100
            return String(format: "%.1f", rate)
        }
    
    var body: some View {
        
        
        Button {
            showDetail = true
        }
        label: {
            // Label: 썸네일 + 메뉴 이름 + 가격
            HStack(alignment: .center, spacing: 12) {
                if let image = headerImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 63, height: 63)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 63, height: 63)
                        .overlay(
                            Image(systemName: "fork.knife")
                        )
                }
                VStack(alignment: .leading) {
                    
                    Text(menuName)
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .padding(.top, 12)
                    
                    Spacer()
                    
                    if totalCost > 0 {
                        Text("재료비 \(totalCost.formatted())원")
                            .font(.footnote)
                            .fontWeight(.regular)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("재료원가 정보 없음")
                            .font(.footnote)
                            .fontWeight(.regular)
                            .foregroundStyle(.secondary)
                    }

                    Text("판매비 \(headerEntity?.menuPrice ?? 1)원")
                        .font(.footnote)
                        .fontWeight(.regular)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 12)
                    
                }
                .frame(height: 80)
                Spacer()
                ZStack {
                    // 배경 원 (100%)
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                        .frame(width: 56, height: 56)
                    
                    // 원가율 표시 원
                    Circle()
                        .trim(from: 0, to: (Double(totalCost) / Double(headerEntity?.menuPrice ?? 1)))
                        .stroke(
                            (Double(totalCost) / Double(headerEntity?.menuPrice ?? 1)) > 0.35 ? Color.red : Color.blue,
                            style: StrokeStyle(lineWidth: 12, lineCap: .square)
                        )
                        .frame(width: 56, height: 56)
                        .rotationEffect(.degrees(-90))
                    
                    // % 숫자
                    HStack(spacing:0) {
                        Group {
                            Text("\(costRateString)")
                                .font(.caption2)
                            Text("%")
                                .font(.system(size: 4))
                        }
                        
                        .fontWeight(.semibold)
                        .foregroundColor((Double(totalCost) / Double(headerEntity?.menuPrice ?? 1)) > 0.35 ? .red : .blue)
    
                    }
                }
                .padding(.top, 4)
                .padding(.trailing, 4)
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.gray.opacity(0.4))

            }
            // ── “기존 확인 모드”로 IngredientResultView를 푸시 ──
            .navigationDestination(isPresented: $showDetail) {
                IngredientResultView(
                    isNew: false,
                    selectedMenuName: .constant(menuName),
                    showAddMenu:      .constant(false),   // “기존 모드” 플래그
                    menuName:         menuName,
                    menuPrice:        priceString,
                    image:            headerImage,
                    parsedIngredients: infos
                )
            }
        }
    }
}
