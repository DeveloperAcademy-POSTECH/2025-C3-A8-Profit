//
//  ContentView.swift
//  Soonsu
//
//  Created by coulson on 6/2/25.
//

import SwiftUI
import SwiftData

struct TabBarView: View {
    
    var body: some View {
        
        TabView {
            
            MyMenuView()
                .tabItem {
                    Image(systemName: "house")
                }
            
            FixedCostManageView(viewModel: ProfitViewModel())
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
    NavigationStack {
        TabBarView()
    }
}
