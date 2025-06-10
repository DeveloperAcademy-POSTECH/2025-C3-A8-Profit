//
//  TextRowComponent.swift
//  Soonsu
//
//  Created by Choi Jung In on 6/11/25.
//

import SwiftUI

struct TextRowComponent: View {
    let title: String
    let content: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(.gray)
            Spacer()
            Text(content)
                .font(.body)
                .fontWeight(.bold)
        }
        .padding(.horizontal)
        .padding(.vertical,8)
    }
}
