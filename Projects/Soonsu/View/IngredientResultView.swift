//
//  IngredientResultView.swift
//  HambJaeryoModal
//
//  Created by coulson on 5/29/25.
//

import SwiftUI
import SwiftData

struct IngredientResultView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @Binding var selectedMenuName: String
    @Binding var showAddMenu: Bool
    
    let menuName: String
    let menuPrice: String
    let image: UIImage?
    let parsedIngredients: [IngredientInfo]
    
    
    private var totalCost: Int {
        parsedIngredients.reduce(0) { $0 + $1.unitPrice }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // ── 헤더 영역 ─────────────────────────────────────
            HStack(alignment: .top, spacing: 16) {
                if let uiImage = image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 64, height: 64)
                        .overlay(
                            Image(systemName: "fork.knife.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .padding(12)
                                .foregroundColor(.orange)
                        )
                }
                
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(menuName)
                        .font(.headline)
                    Text("\(menuPrice)원")
                        .font(.title3).bold()
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            
            // ── 재료 리스트 ──────────────────────────────────
            List {
                ForEach(parsedIngredients) { ing in
                    HStack {
                        // 간단 아이콘 (재료 첫 글자 이모지 활용)
                        Text(String(ing.name.first ?? "🥘"))
                            .font(.system(size: 24))
                        
                        Text(ing.name)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(ing.amount)
                            .font(.subheadline)
                            .frame(width: 60, alignment: .trailing)
                        
                        Text("\(ing.unitPrice.formatted())원")
                            .font(.subheadline)
                            .frame(width: 70, alignment: .trailing)
                        
                        Image(systemName: "chevron.up")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .listRowSeparator(.hidden)
                }
                Button {
                    // 추가 로직 Hook (선택)
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("재료 추가하기")
                    }
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            
            Divider()
            
            
            // ── 하단 합계 + 등록 버튼 ────────────────────────
            VStack(spacing: 16) {
                Text("재료원가는 \(totalCost.formatted())원입니다")
                    .font(.subheadline)
                
                Button("메뉴 등록") {
                    saveMenuWithIngredients()
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
            .background(
                Color(UIColor.systemBackground)
                    .shadow(color: .black.opacity(0.1), radius: 5, y: -2)
            )
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("재료관리")
    }
    
    // MARK: - 저장 & 루트 복귀
    private func saveMenuWithIngredients() {
        do {
            // 1️⃣ 메뉴 가격(String → Int) 변환
            let priceValue = Int(menuPrice) ?? 0
            
            // 2️⃣ 이미지(UIImage → Data) 변환 (JPEG 80% 압축)
            let imageData: Data? = image?.jpegData(compressionQuality: 0.8)
            
            var insertedCount = 0
            
            // 3️⃣ parsedIngredients 배열을 순회하며, 각 재료마다
            //    “같은 메뉴 이름·가격·이미지”를 포함해 삽입
            for info in parsedIngredients {
                let entity = IngredientEntity(
                    menuName: menuName,
                    menuPrice: priceValue,
                    imageData: imageData,
                    info: info
                )
                context.insert(entity)
                insertedCount += 1
            }
            
            // 5️⃣ 실제 저장
            try context.save()
            print("✅ [Debug] context.save() 성공, 총 엔티티 개수: \(insertedCount)")
            
            // 6️⃣ 저장 후 루트 복귀
            selectedMenuName = "\(menuName)-\(UUID().uuidString)"
            dismiss()
            
        } catch {
            print("SwiftData save error:", error)
        }
    }
}
