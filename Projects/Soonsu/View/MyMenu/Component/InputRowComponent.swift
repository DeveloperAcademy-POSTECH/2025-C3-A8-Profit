////
////  InputRow.swift
////  Soonsu
////
////  Created by Choi Jung In on 6/7/25.
////

import SwiftUI

enum Field: Hashable {
        case menuName
        case menuPrice
    }

struct InputRowComponent: View {
    let title: String
    var placeholder: String = ""
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var focusedField: FocusState<Field?>.Binding?
    var unit: String? = nil

    var body: some View {

        VStack {
            HStack(spacing: 0) {
                Text(title)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray)
                Spacer()
                if let binding = focusedField {
                    TextField(placeholder, text: $text)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(.blue)
                        .font(.body)
                        .fontWeight(.bold)
                        .keyboardType(keyboardType)
                        .focused(binding, equals: title == "메뉴 이름" ? .menuName : .menuPrice)
                } else {
                    TextField(placeholder, text: $text)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(.blue)
                        .font(.body)
                        .fontWeight(.bold)
                        .keyboardType(keyboardType)
                }
//                if let unit {
//                    Text(unit)
//                        .foregroundStyle(.blue)
//                        .font(.body)
//                        .fontWeight(.bold)
//                } else {
//                    Text("g")
//                        .foregroundStyle(isEnabled ? .blue : .black)
//                        .font(.body)
//                        .fontWeight(.bold)
//                }
                
                if title == "메뉴 가격" {
                    Text("원")
                        .foregroundStyle(.gray)
                        .font(.body)
                        .fontWeight(.bold)
            }
            }
            .padding(.horizontal)
            .padding(.vertical,4)
        }

    }
}
