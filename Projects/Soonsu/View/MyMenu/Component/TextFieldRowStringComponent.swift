//
//  TextFieldRowComponent.swift
//  Soonsu
//
//  Created by Choi Jung In on 6/11/25.
//

import SwiftUI

struct TextFieldRowStringComponent: View {
    let title: String
    @Binding var content: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(.gray)
            Spacer()
            TextField("", text: $content)
                .multilineTextAlignment(.trailing)
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(.blue)
        }
        .padding(.horizontal)
//        .padding(.vertical,8)
    }
}

