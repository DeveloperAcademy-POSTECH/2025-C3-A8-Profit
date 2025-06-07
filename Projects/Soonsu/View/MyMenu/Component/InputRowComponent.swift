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
        HStack {
            Text(title)
                .font(.body)
                .fontWeight(.bold)
            if let binding = focusedField {
                TextField(placeholder, text: $text)
                    .multilineTextAlignment(.trailing)
                    .foregroundStyle(.black)
                    .font(.body)
                    .fontWeight(.bold)
                    .keyboardType(keyboardType)
                    .focused(binding, equals: title == "메뉴 이름" ? .menuName : .menuPrice)
                    .disabled(!isEnabled)
            } else {
                TextField(placeholder, text: $text)
                    .multilineTextAlignment(.trailing)
                    .foregroundStyle(.black)
                    .font(.body)
                    .fontWeight(.bold)
                    .keyboardType(keyboardType)
                    .disabled(!isEnabled)
            }
        }
    }
}
