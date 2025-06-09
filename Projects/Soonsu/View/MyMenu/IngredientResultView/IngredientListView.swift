//
//  IngredientListView.swift
//  Soonsu
//
//  Created by coulson on 6/9/25.
//

import SwiftUI

struct IngredientListView: View {
    let ingredients: [IngredientInfo]
    let isNew: Bool
    let onAddTapped: () -> Void
    
    var body: some View {
        List {
            ForEach(ingredients) { ing in
                HStack {
                    Text(String(ing.name.first ?? "🥘"))
                        .font(.system(size: 24))
                    Text(ing.name)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(ing.amount)
                        .font(.subheadline)
                        .frame(width: 60, alignment: .trailing)
                    Text("\(ing.unitPrice.formatted())원")
                        .font(.subheadline)
                        .frame(width: 70, alignment: .trailing)
                    Image(systemName: "chevron.up")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .listRowSeparator(.hidden)
            }
            
            if isNew {
                Button {
                    onAddTapped()
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("재료 추가하기")
                    }
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        /*
         ZStack(alignment: .bottom) {
         VStack {
         Spacer()
         .frame(height: 24)
         List {
         ForEach(parsedIngredients) { ing in
         HStack {
         
         Image(uiImage: UIImage(named: ing.name) ?? UIImage(named: "포항초")!)
         .resizable()
         .scaledToFill()
         .frame(width: 24, height: 24)
         
         Text(ing.name)
         .font(.body)
         .frame(maxWidth: .infinity, alignment: .leading)
         
         
         Text("\(String(format: "%.0f", ing.amount))\(ing.unit)")
         .font(.subheadline)
         .frame(width: 60, alignment: .trailing)
         
         
         Text("\(ing.unitPrice.formatted())원")
         .font(.subheadline)
         .foregroundStyle(.gray)
         .frame(width: 70, alignment: .trailing)
         
         Image(systemName: "pencil")
         .font(.body)
         .foregroundColor(.blue)
         }
         .listRowSeparator(.hidden)
         .contentShape(Rectangle())
         .onTapGesture {
         selectedIngredient = ing
         showIngredientModifySheet = true
         }
         }
         .onDelete(perform: deleteIngredient)
         }
         .padding(.horizontal, 4)
         .scrollIndicators(.hidden)
         .listStyle(.plain)
         Spacer()
         .frame(height: 24)
         }
         
         
         VStack {
         LinearGradient(colors: [.white, .white.opacity(0)], startPoint: .top, endPoint: .bottom)
         .frame(height: 64)
         .allowsHitTesting(false)
         
         Spacer()
         
         LinearGradient(colors: [.white, .white.opacity(0)], startPoint: .bottom, endPoint: .top)
         .frame(height: 64)
         .allowsHitTesting(false)
         }
         
         }
         
         */
        
    }
}
