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
    
    // MyMenuView / MenuInputView 에서 전달받을 모드 플래그
    let isNew: Bool                     // true = 신규 등록 모드, false = 기존 확인 모드
    @Binding var selectedMenuName: String
    @Binding var showAddMenu: Bool      // MyMenuView 쪽에서 이 바인딩을 false로 바꿔가며 pop 처리
    
    
    @State private var selectedExistingMenuName: String? = nil
    
    
    let menuName: String
    let menuPrice: String
    let image: UIImage?
    
    
    //    @State var parsedIngredients: [IngredientInfo]
    //    let mode: ResultMode
    
    
    // AI가 파싱해준 초기 재료들을 이 State 배열로 복사하여 관리합니다.
    @State private var ingredients: [IngredientInfo]
    
    
    // “재료 추가하기” 네비게이션 푸시 트리거
    @State private var navigateToSearch = false
    
    
//    @State private var showIngredientAddView = false
    //    @State private var navigateToIngredientAddView = false
    
    
    // 팝오버(원형 진행률) 표시 트리거
    @State private var showProgressPopover = false
    
    
    @State private var selectedIngredient: IngredientInfo? = nil
    
    // 재료 수정 바텀 시트 트리거
    @State private var showIngredientModifySheet = false
    
    
    
    //    private var totalCost: Double {
    //        parsedIngredients.reduce(0) { $0 + $1.unitPrice }
    //    }
    
    
    
    // 원가율 계산 (재료원가 합계 / 메뉴가격 * 100)
    private var percentage: Double {
        let totalCost = ingredients.reduce(0) { $0 + $1.unitPrice }
        let menuValue = Double(Int(menuPrice) ?? 1)
        guard menuValue > 0 else { return 0 }
        return (Double(totalCost) / menuValue) * 100.0
    }
    
    
    private var totalCost: Int {
        //        parsedIngredients.reduce(0) { $0 + $1.unitPrice }
        ingredients.reduce(0) { $0 + $1.unitPrice }
    }
    
    
    // 초기화 시 parsedIngredients를 ingredients에 복사
    init(
        isNew: Bool,
        selectedMenuName: Binding<String>,
        showAddMenu: Binding<Bool>,
        menuName: String,
        menuPrice: String,
        image: UIImage?,
        parsedIngredients: [IngredientInfo]
    ) {
        self.isNew = isNew
        _selectedMenuName = selectedMenuName
        _showAddMenu = showAddMenu
        self.menuName = menuName
        self.menuPrice = menuPrice
        self.image = image
        // parsedIngredients를 State인 ingredients로 복사
        _ingredients = State(initialValue: parsedIngredients)
    }
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
                
                // ── 헤더 영역 ─────────────────────────────────────
                // ── 상단 헤더: 메뉴 이미지·이름·가격
                IngredientHeaderView(
                    menuName: menuName,
                    menuPrice: menuPrice,
                    image: image
                )
                
                
                // ── 재료 리스트 + “재료 추가하기” 버튼(신규 등록 모드일 때만)
                IngredientListView(
                    ingredients: ingredients)
                {
                    selectedIng in
                    showIngredientModifySheet = true
                    selectedIngredient = selectedIng
                }
                
//                Divider()
                
                // ── 하단 합계 + 등록 버튼 ────────────────────────
                
                IngredientResultFooterView(
                    totalCost: totalCost,
                    isNew: isNew,
                    onPrimaryTapped: {
                        if isNew {
                            // 신규 등록 모드: 팝오버 띄우기
                            showProgressPopover = true
                        } else {
                            // MARK: 질문 - 수정 사항이 반영이 안됨 
                            // 기존 확인 모드: 저장 후 뒤로 팝
//                            do {
//                                try context.save()
//                                print("✅ 수정 저장됨")
//                                selectedMenuName = "\(menuName)-\(UUID().uuidString)" // MyMenu 갱신 유도
//                                dismiss()
//                            } catch {
//                                print("❌ 저장 실패:", error)
//                            }
                            // 🆕 Delete existing ingredients for this menuName before saving new ones
                            let fetchDescriptor = FetchDescriptor<Ingredient>(predicate: #Predicate { $0.menuName == menuName })
                            if let existing = try? context.fetch(fetchDescriptor) {
                                for item in existing {
                                    context.delete(item)
                                }
                            }
                            for info in ingredients {
                                let entity = Ingredient(
                                    menuName: menuName,
                                    menuPrice: Int(menuPrice) ?? 0,
                                    imageData: image?.jpegData(compressionQuality: 0.8),
                                    info: info
                                )
                                context.insert(entity)
                                
                            }
                            do {
                                try context.save()
                                print("✅ 수정 저장됨")
                                selectedMenuName = "\(menuName)-\(UUID().uuidString)"
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    dismiss()
                                }
                            } catch {
                                print("❌ 저장 실패:", error)
                            }
                        }
                    },
                    onAddTapped: {
                        navigateToSearch = true
                    }
                )
            }
            
            //
            .ignoresSafeArea(.keyboard)
            //                .navigationBarBackButtonHidden(true)
            .navigationTitle("재료관리")
            
//            .ingredientModifySheet(
//                isPresented: $showIngredientModifySheet,
//                ingredients: $ingredients,
//                selectedIngredient: $selectedIngredient
//            )
            .ingredientModifySheet(
                selectedIngredient: $selectedIngredient,
                ingredients: $ingredients
            )
            
            .navigationDestination(
                isPresented: $navigateToSearch,
                destination: {
                    IngredientAddView(parsedIngredients: $ingredients) { selectedItemName in
                        // 네비게이션에서 돌아올 때 호출됨
                        // 유효한 재료명이라면 ingredients에 append
                        if !selectedItemName.isEmpty {
                            let newIng = IngredientInfo(
                                name: selectedItemName,
                                amount: "0g",
                                unitPrice: 0
                            )
                            ingredients.append(newIng)
                        }
                    }
                }
            )
            

            
            // ──────────────── 팝오버 (원형 진행률) ─────────────────
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
        //        print("✅ [Debug] context.save() 성공, 총 엔티티 개수: \(context)")
        
        saveMenuWithIngredients()
        
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
            for info in ingredients {
                let entity = Ingredient(
                    menuName: menuName,
                    menuPrice: priceValue,
                    imageData: imageData,
                    info: info
                )
                context.insert(entity)
                insertedCount += 1
            }
            print("🚀 [Debug] 삽입할 Entity 수: \(insertedCount)")
            
            // 5️⃣ 실제 저장
            try context.save()
            print("✅ [Debug] context.save() 성공, 총 엔티티 개수: \(insertedCount)")
            
            // 6️⃣ 저장 후 루트 복귀
            selectedMenuName = "\(menuName)-\(UUID().uuidString)"
//                        dismiss()
            
        } catch {
            print("SwiftData save error:", error)
        }
    }
}
