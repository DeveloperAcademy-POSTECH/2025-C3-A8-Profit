//
//  TextFieldRowComponent.swift
//  Soonsu
//
//  Created by Choi Jung In on 6/11/25.
//

import SwiftUI
/*
struct TextFieldRowIntComponent: View {
    let title: String
    @Binding var content: Int
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(.gray)
            
            Spacer()
            
            HStack(spacing: 0) {
                Group {
                    TextField("", value: $content, formatter: NumberFormatter())
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                    Text("원")
                }
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(.blue)
            }
            

        }
        
        .padding(.horizontal)
//        .padding(.vertical,8)
    }
}

import SwiftUI
*/
struct TextFieldRowIntComponent: View {
    let title: String
    @Binding var content: Int
    
    // 1️⃣ 포커스 상태 감지용 상태 추가
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(.gray)
            
            Spacer()
            
            HStack(spacing: 0) {
                Group {
                    TextField("", value: $content, formatter: NumberFormatter())
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                        .focused($isFocused) // 2️⃣ 포커스 연결
                    Text("원")
                }
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(.blue)
            }
        }
        .padding(.horizontal)
        
        // 3️⃣ 키보드 툴바에 완료 버튼 추가
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("완료") {
                    isFocused = false
                }
            }
        }
    }
}
