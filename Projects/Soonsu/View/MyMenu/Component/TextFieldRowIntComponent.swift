//
//  TextFieldRowComponent.swift
//  Soonsu
//
//  Created by Choi Jung In on 6/11/25.
//

import SwiftUI

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

