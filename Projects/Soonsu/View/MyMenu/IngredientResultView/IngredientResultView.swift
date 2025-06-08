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
    @State var parsedIngredients: [IngredientInfo]
    let mode: ResultMode
    
    
    @State private var showIngredientAddView = false
    @State private var navigateToIngredientAddView = false
    
    @State private var showProgressPopover = false
    @State private var selectedIngredient: IngredientInfo? = nil
    @State private var showIngredientModifySheet = false
    

    
    private var totalCost: Double {
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
        print("📌 handleSave() 실행됨. mode: \(mode)")
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
                    HStack(spacing: 16) {
                        if let uiImage = image {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
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
                                .font(.title3).bold()
                            Text("\(menuPrice)원")
                                .font(.headline).bold()
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom,4)
                    
                    
                    // ── 재료 리스트 ──────────────────────────────────
                    
                    ZStack(alignment: .bottom) {
                        VStack {
                            Spacer()
                                .frame(height: 24)
                            List {
                                ForEach(parsedIngredients) { ing in
                                    HStack {
                                        
                                        Image(uiImage: UIImage(named: ing.name) ?? UIImage(named: "포항초")!)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 24, height: 24)
                                        
                                        Text(ing.name)
                                            .font(.body)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        
                                        Text("\(String(format: "%.0f", ing.amount))\(ing.unit)")
                                            .font(.subheadline)
                                            .frame(width: 60, alignment: .trailing)
                                            
                                        
                                        Text("\(ing.unitPrice.formatted())원")
                                            .font(.subheadline)
                                            .foregroundStyle(.gray)
                                            .frame(width: 70, alignment: .trailing)
                                        
                                        Image(systemName: "pencil")
                                            .font(.body)
                                            .foregroundColor(.blue)
                                    }
                                    .listRowSeparator(.hidden)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selectedIngredient = ing
                                        showIngredientModifySheet = true
                                    }
                                }
                                .onDelete(perform: deleteIngredient)
                            }
                            .padding(.horizontal, 4)
                            .scrollIndicators(.hidden)
                            .listStyle(.plain)
                            Spacer()
                                .frame(height: 24)
                        }

                        
                        VStack {
                            LinearGradient(colors: [.white, .white.opacity(0)], startPoint: .top, endPoint: .bottom)
                                .frame(height: 64)
                                .allowsHitTesting(false)
                            
                            Spacer()
                            
                            LinearGradient(colors: [.white, .white.opacity(0)], startPoint: .bottom, endPoint: .top)
                                .frame(height: 64)
                                .allowsHitTesting(false)
                        }
                        
                    }
                    

                    
                    // ── 하단 합계 + 등록 버튼 ────────────────────────
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(.blue)
                            NavigationLink("재료 추가하기") {
                                IngredientAddView(onIngredientSelected: { selectedName in
                                    guard !parsedIngredients.contains(where: { $0.name == selectedName }) else { return }
                                    let newInfo = IngredientInfo(name: selectedName, amount: 10, unit:"g", unitPrice: 100)
                                    parsedIngredients.append(newInfo)
                                })
                            }
                        }
                        

                        
                        HStack(spacing:0) {
                            Group {
                                Text("재료원가는")
                                    .foregroundStyle(.gray)
                                Text(totalCost.formatted())
                                    .foregroundStyle(.blue)
                                Text("원입니다")
                                    .foregroundStyle(.gray)
                            }
                            .font(.title3)
                            .fontWeight(.bold)
                        }
                        .padding(.bottom)
                        

                        
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
                }
                .ignoresSafeArea(.keyboard)
//                .navigationBarBackButtonHidden(true)
                .navigationTitle("재료관리")
                .ingredientModifySheet(isPresented: $showIngredientModifySheet, parsedIngredients: $parsedIngredients, selectedIngredient: $selectedIngredient)
                
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


    // MARK: 재료 추가 & 시트 닫기
    private func closePopoverAndSave() {
        print("📌 closePopoverAndSave() 실행됨")
        showProgressPopover = false
        handleSave()
//        print("✅ [Debug] context.save() 성공, 총 엔티티 개수: \(context)")

    }
    
    // MARK: 재료 슬라이드 삭제
    private func deleteIngredient(at offsets: IndexSet) {
        parsedIngredients.remove(atOffsets: offsets)
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
//            dismiss()
            
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

private extension View {
    func ingredientModifySheet(
        isPresented: Binding<Bool>,
        parsedIngredients: Binding<[IngredientInfo]>,
        selectedIngredient: Binding<IngredientInfo?>
    ) -> some View {
        self.sheet(isPresented: isPresented) {
            if let selIngredient = selectedIngredient.wrappedValue,
               let index = parsedIngredients.wrappedValue.firstIndex(where: { $0.id == selIngredient.id }) {
                IngredientModifyComponent(
                    ingredient: parsedIngredients.wrappedValue[index],
                    parsedIngredients: parsedIngredients
                )
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
