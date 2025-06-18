//
//  IngredientSheetView.swift
//  HambJaeryoModal
//
//  Created by coulson on 5/28/25.
//

import SwiftUI
import PhotosUI
import FirebaseAI
import SwiftData
import Lottie

struct MenuInputView: View {
    
    
    @Binding var showAddMenu: Bool
    @Binding var selectedMenuName: String
    
    
    
    @State private var isLoading = false
    @State private var navigateToResult = false
    @State private var showBackConfirmDialog = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var menuName: String = ""
    @State private var menuPrice: String = ""
    @State private var parsedIngredients: [IngredientInfo] = []
    @FocusState private var focusedField: Field?
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    
    
    
    private var model: GenerativeModel?
    
    
    init(
        showAddMenu: Binding<Bool>,
        selectedMenuName: Binding<String>,
        firebaseService: FirebaseAI = FirebaseAI.firebaseAI()
    ) {
        _showAddMenu  = showAddMenu
        _selectedMenuName = selectedMenuName
        self.model = firebaseService.generativeModel(modelName: "gemini-2.0-flash-001")
    }
    
    var body: some View {
        
        ZStack {
            ScrollView {
                
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    if let image = selectedImage {
                        RoundedRectangle(cornerRadius: 32)
                            .fill(Color.clear)
                            .frame(height: 360)
                            .overlay {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:360, height: 360)
                                    .clipShape(RoundedRectangle(cornerRadius: 32))
                            }
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 32)
                                .fill(Color.blue.opacity(0.1))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                            VStack {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 100, height: 100)
                                    Image(systemName: "photo.badge.plus")
                                        .font(.system(size: 20))
                                        .foregroundColor(.blue)
                                }
                                .padding(.bottom, 40)
                                Text(
                                                          """
                                                          사진을 등록하면 자동으로
                                                          재료 원가를 계산해 드릴게요
                                                          """
                                )
                                .multilineTextAlignment(.center)
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.bottom, -8)
                            }
                        }
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                    }
                }
                .frame(width: 360, height: 360)
                .onChange(of: selectedItem) { _, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImage = uiImage
                        }
                    }
                }
                
                Group {
                    InputRowComponent(
                        title: "메뉴 이름",
                        placeholder: "함박스테이크",
                        text: $menuName,
                        focusedField: $focusedField
                    )
                    .padding(.top)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    InputRowComponent(
                        title: "메뉴 가격",
                        placeholder: "10000",
                        text: $menuPrice,
                        keyboardType: .numberPad,
                        focusedField: $focusedField,
                        unit: "원"
                    )
                    .padding(.top)
                    
                    Divider()
                        .padding(.horizontal)
                        .padding(.bottom, 32)
                }
                
                Button {
                    isLoading = true
                    Task {
                        await analyzeIngredients()
                        isLoading = false
                    }
                } label: {
                    Text("재료원가 계산하기")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background((isLoading || selectedImage == nil || menuName.isEmpty || menuPrice.isEmpty) ? Color.gray : Color.primaryColor700)
                .cornerRadius(28)
                .disabled(isLoading || selectedImage == nil || menuName.isEmpty || menuPrice.isEmpty)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
            
            
            
            
            .padding()
            .scrollContentBackground(.hidden)
//            .ignoresSafeArea(.keyboard, edges: .bottom)
            .background(Color(.systemGray6))
            .overlay {
                if isLoading {
                    ZStack {
                        Color.white.opacity(0.8).ignoresSafeArea()
                        VStack(spacing: 8) {
//                            ProgressView()
//                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                                .scaleEffect(2)
                            LottieView(animation: .named("loading"))
                                .looping()
                            Text("재료를 분석 중이에요...")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.bottom, 16)
                        }
                        .padding()
                    }
                }
            }
            // MARK: 키보드 숨김처리
            if focusedField != nil {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        focusedField = nil
                    }
            }
            
        }
        .navigationDestination(isPresented: $navigateToResult) {
            IngredientResultView(
                isNew: true,
                selectedMenuName: $selectedMenuName,
                showAddMenu: $showAddMenu,
                menuName: menuName,
                menuPrice: menuPrice,
                image: selectedImage,
                parsedIngredients: parsedIngredients
            )
        }
        .navigationTitle("재료원가계산")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    let hasInput = selectedImage != nil || !menuName.isEmpty || !menuPrice.isEmpty
                    if hasInput {
                        showBackConfirmDialog = true
                    } else {
                        dismiss()
                    }
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .fontWeight(.bold)
                        Text("나의메뉴")
                    }
                }
            }
        }
        .confirmationDialog("입력한 정보가 사라집니다. 뒤로 가시겠어요?", isPresented: $showBackConfirmDialog, titleVisibility: .visible) {
            Button("뒤로가기", role: .destructive) {
                dismiss()
            }
            Button("취소", role: .cancel) {}
            
        }
    }
    
    // MARK: - Gemini API 호출 및 파싱
    //    // MockData
//    func analyzeIngredients() async {
//        // MockData.json 불러오기
//        guard let url = Bundle.main.url(forResource: "MockData", withExtension: "json") else {
//            print("❌ MockData.json 경로를 찾을 수 없음")
//            return
//        }
//        
//        guard let data = try? Data(contentsOf: url) else {
//            print("❌ MockData.json 파일 읽기 실패")
//            return
//        }
//        
//        guard let decoded = try? JSONDecoder().decode([IngredientInfo].self, from: data) else {
//            print("❌ JSON 디코딩 실패")
//            return
//        }
//        
//        // MainActor에서 상태 업데이트
//        await MainActor.run {
//            parsedIngredients = decoded
//            navigateToResult = true
//        }
//    }
    
    // 실제 데이터
        func analyzeIngredients() async {
            guard let selectedImage,
                  //        guard let imageData = selectedImage.jpegData(compressionQuality: 0.7) else { return }
                  let model else { return }
    
            let prompt =
                                    """
                                        음식 이름: \(menuName)
                                        음식 가격: \(menuPrice)원
                                    
                                        1. 이 명령은 첨부된 사진을 보고, 해당 음식의 재료원가를 파악하기 위한거야.
                                        2. 만약 사진의 내용이 음식이 아니라면 빈 리스트를 제공해줘.
                                        3. 음식 이름과 사진을 참고하여 정확하게 어떤 음식인지 파악하고, 이 음식에 사용된 재료 정보를 다음 JSON 형식으로 제공해줘:
                                    
                                        [
                                          {
                                            "name": "재료명",
                                            "amount": "사용량 및 그램단위 (예: 100g)",
                                            "unitPrice": 단위 원가 (숫자, 원 단위)
                                          },
                                          ...
                                        ]
                                    
                                        - 사용된 재료는 주재료 위주로 구성해줘.
                                        - 신뢰성있고, 최신의 단가 계산 출처로 파악해줘.
                                        - 'unitPrice'는 'amount'의 단위 만큼만 사용했을 때 얼마인지 계산해줘.
                                        - 텍스트 설명 없이 JSON 배열만 출력
                                    """

                
    
            do {
                let parts: [any PartsRepresentable] = [selectedImage]
                var fullText = ""
                for try await chunk in try model.generateContentStream(prompt, parts) {
                    if let text = chunk.text { fullText += text }
                }
    
                // 백틱 제거 및 JSON 추출
                let cleaned = fullText
                    .replacingOccurrences(of: "```json", with: "")
                    .replacingOccurrences(of: "```", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
    
                guard
                    let first = cleaned.firstIndex(of: "["),
                    let last  = cleaned.lastIndex(of: "]"),
                    let data  = String(cleaned[first...last]).data(using: .utf8)
                else { return }
    
    
                let decoded = try JSONDecoder().decode([IngredientInfo].self, from: data)
                // 1️⃣ – Main Thread에서 상태 갱신 및 저장 수행
                await MainActor.run {
                    parsedIngredients = decoded
    
                    // 3️⃣ – 저장이 끝나면 화면 전환
                    navigateToResult = true
                }
    
            } catch {
                print("Gemini API 호출 실패: \(error)")
            }
    
        }
    }
    
    
    
    #Preview {
        IngredientSheetViewPreview()
    }
    
    struct IngredientSheetViewPreview: View {
        @State var showAddMenu = true
        @State var selectedMenuName = "함박스테이크"
        
        var body: some View {
            NavigationStack {
                MenuInputView(
                    showAddMenu: $showAddMenu,
                    selectedMenuName: $selectedMenuName
                )
            }
        }
    }
    
