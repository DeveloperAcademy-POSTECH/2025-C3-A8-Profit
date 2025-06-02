//
//  ContentView.swift
//  Soonsu
//
//  Created by coulson on 6/2/25.
//

import SwiftUI
import SwiftData

struct SSTabView: View {

    var body: some View {
        
        TabView {
            
            SSMyMenuView()
                .tabItem {
                    Image(systemName: "house")
                }
            
            Text("Second")
                .tabItem {
                    Image(systemName: "house")

                }
            
            Text("3")
                .tabItem {
                    Image(systemName: "house")
                }
            Text("4")
                .tabItem {
                    Image(systemName: "house")

                }
        }
        
        
        
    }
}

#Preview {
    SSTabView()
}
