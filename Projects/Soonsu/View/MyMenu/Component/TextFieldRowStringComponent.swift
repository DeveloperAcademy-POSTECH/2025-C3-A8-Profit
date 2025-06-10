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
    @State private var amountString: String = ""
    @State private var unitString: String = ""
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(.gray)
            Spacer()
            HStack(spacing: 0) {
                TextField("", text: $amountString)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundStyle(.blue)
                
                Text(unitString)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundStyle(.blue)
            }

        }
        .padding(.horizontal)
        .onChange(of: amountString) {
            content = "\(amountString)\(unitString)"
        }
        .onAppear {
            (amountString, unitString) = splitContentIntoAmountAndUnit(text: $content.wrappedValue)
        }
    }

}

