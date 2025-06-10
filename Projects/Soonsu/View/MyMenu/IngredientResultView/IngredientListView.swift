//
//  IngredientListView.swift
//  Soonsu
//
//  Created by coulson on 6/9/25.
//

import SwiftUI

struct IngredientListView: View {
    var ingredients: [IngredientInfo]
    let onRowTapped: (IngredientInfo) -> Void
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: 24)
                List {
                    ForEach(ingredients) { ing in
                        HStack {
                            Image(uiImage: UIImage(named: ing.name) ?? UIImage(named: "포항초")!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 24, height: 24)
                            
                            Text(ing.name)
                                .font(.body)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(ing.amount)
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
                            onRowTapped(ing)
                        }
                    }
                }
                .listStyle(.plain)
            }

            VStack{
                LinearGradient(colors: [.white, .white.opacity(0)], startPoint: .top, endPoint: .bottom)
                    .frame(height: 64)
                    .allowsHitTesting(false)
                
                Spacer()
                
                LinearGradient(colors: [.white, .white.opacity(0)], startPoint: .bottom, endPoint: .top)
                    .frame(height: 64)
                    .allowsHitTesting(false)
            }
        }
        .padding(.horizontal,8)
    }
}
