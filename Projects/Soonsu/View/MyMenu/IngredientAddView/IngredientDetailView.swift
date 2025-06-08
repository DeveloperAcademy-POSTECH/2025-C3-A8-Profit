//
//  IngredientDetailView.swift
//  Soonsu
//
//  Created by Choi Jung In on 6/8/25.
//

import SwiftUI

struct IngredientDetailView: View {
    let name: String
    var body: some View {
        Text(name)
            .font(.largeTitle)
            .padding()
    }
}
