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
    /*
     private var headerImage: UIImage? {
     guard
     let data = headerEntity?.imageData,
     let uiImage = UIImage(data: data)
     else { return nil }
     return uiImage
     }
     */
    
    /// 헤더 가격(String) 준비
    private var priceString: String {
        headerEntity.map { String($0.menuPrice) } ?? ""
    }
    /*
     private var priceString: String {
     if let price = headerEntity?.menuPrice {
     return String(price)
     } else {
     return ""
     }
     }
     */
    
    /// 재료 리스트용 IngredientInfo 배열
    private var infos: [IngredientInfo] {
        matchedEntities.map {
            IngredientInfo(
                name: $0.name,
                amount: $0.amount,
                unit: $0.unit,
                unitPrice: $0.unitPrice
            )
        }
    }
    
    /// 총 원가(Int)
    private var totalCost: Double {
        matchedEntities.reduce(0) { $0 + $1.unitPrice }
    }
    
    
    /// 원가율 (Double 백분율 값, 소수점 첫째자리까지)
    private var costRateString: String {
        guard let price = headerEntity?.menuPrice, price > 0 else { return "-" }
        let rate = (Double(totalCost) / Double(price)) * 100
        return String(format: "%.1f", rate)
    }
    
    var body: some View {

        NavigationLink {
            NavigationStack {
                IngredientResultView(
                    selectedMenuName: .constant(menuName),
                    showAddMenu:      .constant(false),
                    menuName:         menuName,
                    menuPrice:        priceString,
                    image:            headerImage,
                    parsedIngredients: infos,
                    mode: .edit(existingEntities: matchedEntities)
                )
                .navigationBarBackButtonHidden(false)
            }
        } label: {
            // Label: 썸네일 + 메뉴 이름 + 가격
            HStack(spacing: 12) {
                if let thumb = headerImage {
                    Image(uiImage: thumb)
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
                VStack {
                    HStack {
                        Text(menuName)
                            .font(.system(size: 17))
                            .fontWeight(.semibold)
                        Spacer()
                        Text("재료원가 \(totalCost)원")
                            .font(.footnote)
                            .fontWeight(.regular)
                            .foregroundStyle(.secondary)
                        
                    }
                    HStack {
                        //                        Text("그래프")
                        Spacer()
                        Text("원가율 \(costRateString)%")
                            .font(.footnote)
                            .fontWeight(.regular)
                            .foregroundStyle(.blue)
                    }
                }
            }
            // ── “기존 확인 모드”로 IngredientResultView를 푸시 ──
            .navigationDestination(isPresented: $showDetail) {
                IngredientResultView(
                    selectedMenuName: .constant(menuName),
                    showAddMenu:      .constant(false),   // “기존 모드” 플래그
                    menuName:         menuName,
                    menuPrice:        priceString,
                    image:            headerImage,
                    parsedIngredients: infos,
                    mode: .create
                )
            }
        }
    }
}

#Preview {
    // Preview를 위해 더미 데이터를 넣어볼 수도 있습니다.
    MenuRowView(menuName: "예시메뉴")
        .modelContainer(for: [Ingredient.self], inMemory: true)
}
