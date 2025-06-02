//
//  AddMenuView.swift
//  Profit_main
//
//  Created by Mumin on 5/28/25.
//

import SwiftUI

// MARK: - 메뉴 추가 뷰
/// 새로운 메뉴를 추가하기 위한 모달 시트 뷰
struct AddMenuView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @Binding var menuItems: [MenuItem]
    
    // MARK: - State Properties
    @State private var menuName: String = ""           // 메뉴 이름
    @State private var menuPrice: String = ""          // 메뉴 가격
    @State private var showingImagePicker = false      // 이미지 피커 표시 상태
    @State private var selectedImage: UIImage?         // 선택된 이미지
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 상단 네비게이션
                navigationHeader
                
                // 메인 컨텐츠
                mainContent
                
                Spacer()
                
                // 하단 버튼
                addButton
            }
            .background(Color(UIColor.systemGray6))
        }
    }
}

// MARK: - AddMenuView Extensions
extension AddMenuView {
    
    /// 상단 네비게이션 헤더
    private var navigationHeader: some View {
        HStack {
            Spacer()
            
            Text("재료원가 계산")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
    }
    
    /// 메인 컨텐츠 영역
    private var mainContent: some View {
        VStack(spacing: 20) {
            // 사진 업로드 영역
            photoUploadSection
            
            // 입력 필드 영역
            inputFieldsSection
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
    }
    
    /// 사진 업로드 섹션
    private var photoUploadSection: some View {
        VStack(spacing: 16) {
            Button(action: {
                showingImagePicker = true
            }) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 300)
                    .overlay(
                        VStack(spacing: 16) {
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: .infinity, maxHeight: 300)
                                    .clipped()
                                    .cornerRadius(12)
                            } else {
                                VStack(spacing: 12) {
                                    Text("사진을 등록하면 자동으로")
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                    Text("재료 원가를 계산해 드릴게요")
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                    
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 60, height: 60)
                                        .overlay(
                                            Image(systemName: "camera.fill")
                                                .font(.system(size: 24))
                                                .foregroundColor(.blue)
                                        )
                                }
                            }
                        }
                    )
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
    
    /// 입력 필드 섹션
    private var inputFieldsSection: some View {
        VStack(spacing: 16) {
            // 메뉴 이름 입력
            inputField(
                title: "메뉴 이름",
                placeholder: "함박스테이크",
                text: $menuName
            )
            
            // 메뉴 가격 입력
            inputField(
                title: "메뉴 가격",
                placeholder: "14,900원",
                text: $menuPrice,
                keyboardType: .numberPad
            )
        }
    }
    
    /// 입력 필드 컴포넌트
    private func inputField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            TextField(placeholder, text: text)
                .font(.system(size: 16))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white)
                .cornerRadius(8)
                .keyboardType(keyboardType)
        }
    }
    
    /// 재료원가 계산하기 버튼
    private var addButton: some View {
        Button(action: {
            addNewMenu()
        }) {
            Text("재료원가 계산하기")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.gray)
                .cornerRadius(8)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 34) // Safe area 고려
        .disabled(menuName.isEmpty || menuPrice.isEmpty)
    }
    
    /// 새 메뉴 추가 함수
    private func addNewMenu() {
        // 가격에서 숫자만 추출
        let priceString = menuPrice.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        let price = Int(priceString) ?? 0
        
        // 임시로 30% 수익률 설정 (실제로는 AI 분석 결과 사용)
        let newMenuItem = MenuItem(
            name: menuName,
            cost: Int(Double(price) * 0.7), // 임시로 70%를 재료비로 계산
            profitMargin: 30.0
        )
        
        menuItems.append(newMenuItem)
        dismiss()
    }
}

// MARK: - 이미지 피커
/// UIImagePickerController를 SwiftUI에서 사용하기 위한 래퍼
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// MARK: - Preview
#Preview {
    AddMenuView(menuItems: .constant([]))
} 