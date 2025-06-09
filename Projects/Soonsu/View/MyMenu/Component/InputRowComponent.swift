////
////  InputRow.swift
////  Soonsu
////
////  Created by Choi Jung In on 6/7/25.
////
//
//import SwiftUI
//
//struct InputRowComponent: View {
//    let title: String
//    var placeholder: String = ""
//    @Binding var text: String
//    var keyboardType: UIKeyboardType = .default
//    var focusedField: FocusState<MenuInputView.Field?>.Binding?
//    var isEnabled: Bool = true
//    var unit: String? = nil
//
//    var body: some View {
//
//        VStack {
//            HStack(spacing: 0) {
//                Text(title)
//                    .font(.body)
//                    .fontWeight(.bold)
//                    .foregroundStyle(.gray)
//                Spacer()
//                if let binding = focusedField {
//                    TextField(placeholder, text: $text)
//                        .multilineTextAlignment(.trailing)
//                        .foregroundStyle(isEnabled ? .blue : .black)
//                        .font(.body)
//                        .fontWeight(.bold)
//                        .keyboardType(keyboardType)
//                        .focused(binding, equals: title == "메뉴 이름" ? .menuName : .menuPrice)
//                        .disabled(!isEnabled)
//                } else {
//                    TextField(placeholder, text: $text)
//                        .multilineTextAlignment(.trailing)
//                        .foregroundStyle(isEnabled ? .blue : .black)
//                        .font(.body)
//                        .fontWeight(.bold)
//                        .keyboardType(keyboardType)
//                        .disabled(!isEnabled)
//                }
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
//            }
//            .padding(.horizontal)
//            .padding(.vertical,4)
//        }
//
//    }
//}
//
//
//#Preview {
//    struct Preview: View {
//        @State private var value = "1000"
//        var body: some View {
//            InputRowComponent(
//                title: "구매 금액",
//                placeholder: "1000",
//                text: $value,
//                keyboardType: .numberPad,
//                isEnabled: true,
//                unit: "원"
//            )
//        }
//    }
//    return Preview()
//}
