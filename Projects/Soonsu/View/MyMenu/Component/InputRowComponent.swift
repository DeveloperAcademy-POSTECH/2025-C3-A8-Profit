//
//  InputRow.swift
//  Soonsu
//
//  Created by Choi Jung In on 6/7/25.
//

import SwiftUI

struct InputRowComponent: View {
    let title: String
    var placeholder: String = ""
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var focusedField: FocusState<MenuInputView.Field?>.Binding?
    var isEnabled: Bool = true

    var body: some View {
        
        VStack {
            HStack {
                Text(title)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray)
                if let binding = focusedField {
                    TextField(placeholder, text: $text)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(isEnabled ? .blue : .black)
                        .font(.body)
                        .fontWeight(.bold)
                        .keyboardType(keyboardType)
                        .focused(binding, equals: title == "메뉴 이름" ? .menuName : .menuPrice)
                        .disabled(!isEnabled)
                } else {
                    TextField(placeholder, text: $text)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(isEnabled ? .blue : .black)
                        .font(.body)
                        .fontWeight(.bold)
                        .keyboardType(keyboardType)
                        .disabled(!isEnabled)
                }
            }
            .padding(.horizontal)
            .padding(.vertical,8)
        }

    }
}
