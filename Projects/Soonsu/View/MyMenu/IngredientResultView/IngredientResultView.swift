//
//  IngredientResultView.swift
//  HambJaeryoModal
//
//  Created by coulson on 5/29/25.
//

import SwiftUI
import SwiftData


enum ResultMode : Equatable {
    case create  // 새로 등록
    case edit(existingEntities: [Ingredient])  // 기존 편집
}

struct IngredientResultView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @Binding var selectedMenuName: String
    @Binding var showAddMenu: Bool
    
    let menuName: String
    let menuPrice: String
    let image: UIImage?
//    let parsedIngredients: [IngredientInfo]
    @State var parsedIngredients: [IngredientInfo]
    let mode: ResultMode
    
    @State private var showIngredientAddView = false
    @State private var showProgressPopover = false
    
    
    private var totalCost: Int {
        parsedIngredients.reduce(0) { $0 + $1.unitPrice }
    }
    
    // 원가율 계산 (재료원가 합계 / 메뉴가격 * 100)
    private var percentage: Double {
        let totalCost = parsedIngredients.reduce(0) { $0 + $1.unitPrice }
        let menuValue = Double(Int(menuPrice) ?? 1)
        guard menuValue > 0 else { return 0 }
        return (Double(totalCost) / menuValue) * 100.0
    }
    
    private func handleSave() {
        switch mode {
        case .create:
            createMenuWithIngredients()
        case .edit(let existingEntities):
            updateIfChanged(existingEntities: existingEntities)
        }
    }
    
    var body: some View {
        ZStack {
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
                .padding(.vertical)
                
                
                // ── 재료 리스트 ──────────────────────────────────
                List {
                    ForEach(parsedIngredients) { ing in
                        HStack {
                            // 간단 아이콘 (재료 첫 글자 이모지 활용)
                            Image(systemName: "photo")
                                .font(.system(size: 20))
                                .foregroundStyle(Color.gray.opacity(0.2))
                            
                            Text(ing.name)
                                .font(.body)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(ing.amount)
                                .font(.subheadline)
                                .frame(width: 60, alignment: .trailing)
                            
                            Text("\(ing.unitPrice.formatted())원")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .frame(width: 70, alignment: .trailing)
                            
                            Image(systemName: "chevron.up")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                
                Divider()
                
                
                // ── 하단 합계 + 등록 버튼 ────────────────────────
                VStack(spacing: 16) {
                    Button {
                        showIngredientAddView = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("재료 추가하기")
                        }
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .listRowSeparator(.hidden)
                    Text("재료원가는 \(totalCost.formatted())원입니다")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Button(mode == .create ? "메뉴 등록" : "확인") {
                        showProgressPopover = true
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
            .sheet(isPresented: $showIngredientAddView) {
                IngredientAddView { selectedName in
                    guard !selectedName.isEmpty else { return }
                    let newIngredient = IngredientInfo(name: selectedName, amount: "", unitPrice: 0)
                    parsedIngredients.append(newIngredient)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("재료관리")
            
            if showProgressPopover {
                // 배경을 어둡게 깔아줌
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                
                // 터치 시 팝오버 해제 + 저장 로직 실행
                    .onTapGesture {
                        closePopoverAndSave()
                    }
                
                CircularProgressComponent(
                    percentage: percentage,
                    menuName: menuName
                ) {
                    // “완료” 버튼 눌렀을 때
                    closePopoverAndSave()
                }
                // ZStack의 중앙에 위치하도록 전체 프레임을 채우고 정렬
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .zIndex(1)
            }
        }
    }

    
    private func closePopoverAndSave() {
        showProgressPopover = false
        handleSave()
    }
        
    
    
    
    // MARK: - 저장 & 루트 복귀
    private func createMenuWithIngredients() {
        do {
            // 1️⃣ 메뉴 가격(String → Int) 변환
            let priceValue = Int(menuPrice) ?? 0
            
            // 2️⃣ 이미지(UIImage → Data) 변환 (JPEG 80% 압축)
            let imageData: Data? = image?.jpegData(compressionQuality: 0.8)
            
            var insertedCount = 0
            
            // 3️⃣ parsedIngredients 배열을 순회하며, 각 재료마다
            //    “같은 메뉴 이름·가격·이미지”를 포함해 삽입
            for info in parsedIngredients {
                let entity = Ingredient(
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
    
    
    private func updateIfChanged(existingEntities: [Ingredient]) {
        var changed = false

        for info in parsedIngredients {
            // 기존 재료 중 같은 이름이 있는지 찾기
            if let match = existingEntities.first(where: { $0.name == info.name }) {
                // 수량 또는 단가가 변경되었을 경우 업데이트
                if match.amount != info.amount || match.unitPrice != info.unitPrice {
                    match.amount = info.amount
                    match.unitPrice = info.unitPrice
                    changed = true
                }
            } else {
                // 새로 추가된 재료인 경우 삽입
                let entity = Ingredient(
                    menuName: menuName,
                    menuPrice: Int(menuPrice) ?? 0,
                    imageData: image?.jpegData(compressionQuality: 0.8),
                    info: info
                )
                context.insert(entity)
                changed = true
            }
        }

        if changed {
            do {
                try context.save()
                print("🔄 변경 사항 저장 완료")
            } catch {
                print("❌ 저장 실패: \(error)")
            }
        } else {
            print("✅ 변경사항 없음 - 저장 생략")
        }
        dismiss()
    }
}
