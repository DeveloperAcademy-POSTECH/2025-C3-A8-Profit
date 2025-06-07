//
//  InputRow.swift
//  Soonsu
//
//  Created by Choi Jung In on 6/7/25.
//

import SwiftUI

struct InputRowComponent: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
//    @FocusState.Binding var focusedField: MenuInputView.Field??
    var focusedField: FocusState<MenuInputView.Field?>.Binding?

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
            } else {
                TextField(placeholder, text: $text)
                    .multilineTextAlignment(.trailing)
                    .foregroundStyle(.black)
                    .font(.body)
                    .fontWeight(.bold)
                    .keyboardType(keyboardType)
            }
        }
    }
}
