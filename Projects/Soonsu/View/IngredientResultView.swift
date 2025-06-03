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
    case edit(existingEntities: [IngredientEntity])  // 기존 편집
}

struct IngredientResultView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
<<<<<<< HEAD
    // MyMenuView / MenuInputView 에서 전달받을 모드 플래그
    let isNew: Bool                   // true = 신규 등록 모드, false = 기존 확인 모드
=======
>>>>>>> temporary
    @Binding var selectedMenuName: String
    @Binding var showAddMenu: Bool    // MyMenuView 쪽에서 이 바인딩을 false로 바꿔가며 pop 처리
    
    let menuName: String
    let menuPrice: String
    let image: UIImage?
//    let parsedIngredients: [IngredientInfo]
    @State var parsedIngredients: [IngredientInfo]
    let mode: ResultMode
    
    @State private var showIngredientAddView = false
    
    
    private var totalCost: Int {
<<<<<<< HEAD
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
            // ──────────────── 메인 콘텐츠 ─────────────────
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
                    //                ForEach(parsedIngredients) { ing in
                    ForEach(ingredients) { ing in
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
                    // “재료 추가하기” 버튼은 신규 등록 모드에서만 노출
                    if isNew {
                        Button {
                            // 추가 로직 Hook
                            navigateToSearch = true
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
                }
                .listStyle(.plain)
                
                Divider()
                
                // ── 하단 합계 + 등록 버튼 ────────────────────────
                VStack(spacing: 16) {
                    Text("재료원가는 \(totalCost.formatted())원입니다")
                        .font(.subheadline)
                    
                    // 버튼 레이블을 모드에 따라 다르게 표시
                    Button(isNew ? "메뉴 등록" : "확인") {
                        if isNew {
                            // 신규 등록 모드: 팝오버 띄우기
                            showProgressPopover = true
                        } else {
                            // 기존 확인 모드: 바로 뒤로 팝
                            dismiss()
                        }
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isNew ? Color.blue : Color.gray.opacity(0.3))
                    .foregroundColor(isNew ? .white : .black)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
                .background(
                    Color(UIColor.systemBackground)
                        .shadow(color: .black.opacity(0.1), radius: 5, y: -2)
                )
            }
            .ignoresSafeArea(.keyboard)
            //        .navigationBarBackButtonHidden(true)
            .navigationTitle("재료관리")
            
            .onAppear {
                print("🟡 [Debug] IngredientResultView 진입, parsedIngredients.count = \(ingredients.count)")
            }
            // ── 네비게이션 푸시 방식으로 SSAddIngredientView 연결 ─────────────────────────
            .navigationDestination(
                isPresented: $navigateToSearch,
                destination: {
                    IngredientAddView { selectedItemName in
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
                        // 화면이 자동으로 뒤로 팝됩니다(SSAddIngredientView에서 dismiss 처리).
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
                
                SSCircularProgressComponent(
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
=======
        parsedIngredients.reduce(0) { $0 + $1.unitPrice }
    }
    
    private func handleSave() {
        switch mode {
        case .create:
            createMenuWithIngredients()
        case .edit(let existingEntities):
            updateIfChanged(existingEntities: existingEntities)
>>>>>>> temporary
        }
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
            .padding(.vertical)
            
            
            // ── 재료 리스트 ──────────────────────────────────
            List {
                ForEach(parsedIngredients) { ing in
                    HStack {
                        // 간단 아이콘 (재료 첫 글자 이모지 활용)
                        Image(systemName: "photo")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.gray.opacity(0.2))
//                        Text(String(ing.name.first ?? "🥘"))
//                            .font(.system(size: 24))
                        
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
                
//                Button("메뉴 등록") {
                Button(mode == .create ? "메뉴 등록" : "확인") {
                    handleSave()
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
    
    
    private func updateIfChanged(existingEntities: [IngredientEntity]) {
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
                let entity = IngredientEntity(
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


