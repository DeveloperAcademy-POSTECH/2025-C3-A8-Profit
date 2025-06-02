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
    
    /// 해당 메뉴명에 속한 IngredientEntity를 모두 가져오는 computed 프로퍼티
    private var matchedEntities: [IngredientEntity] {
        let predicate = #Predicate<IngredientEntity> { $0.menuName == menuName }
        let descriptor = FetchDescriptor<IngredientEntity>(
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
    private var headerEntity: IngredientEntity? {
        matchedEntities.first
    }
    
    /// 헤더 이미지(UIImage?) 준비
    private var headerImage: UIImage? {
        guard
            let data = headerEntity?.imageData,
            let uiImage = UIImage(data: data)
        else { return nil }
        return uiImage
    }
    
    /// 헤더 가격(String) 준비
    private var priceString: String {
        if let price = headerEntity?.menuPrice {
            return String(price)
        } else {
            return ""
        }
    }
    
    /// 재료 리스트용 IngredientInfo 배열
    private var infos: [IngredientInfo] {
        matchedEntities.map {
            IngredientInfo(
                name:      $0.name,
                amount:    $0.amount,
                unitPrice: $0.unitPrice
            )
        }
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
                    parsedIngredients: infos
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
                        if let price = Int(priceString) {
                            Text("재료원가 \(price.formatted())원")
                                .font(.footnote)
                                .fontWeight(.regular)
                                .foregroundStyle(.secondary)
                        } else {
                            Text("재료원가 정보 없음")
                                .font(.footnote)
                                .fontWeight(.regular)
                                .foregroundStyle(.secondary)
                        }
                    }
                    HStack {
                        Text("그래프")
                        Spacer()
                        Text("원가율 \(priceString)%")
                            .font(.footnote)
                            .fontWeight(.regular)
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
    }
}

#Preview {
    // Preview를 위해 더미 데이터를 넣어볼 수도 있습니다.
    MenuRowView(menuName: "예시메뉴")
        .modelContainer(for: [IngredientEntity.self], inMemory: true)
}
