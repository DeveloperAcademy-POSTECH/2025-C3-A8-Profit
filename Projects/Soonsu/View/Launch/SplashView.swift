//
//  SplashView.swift
//  Soonsu
//
//  Created by coulson on 6/11/25.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false

    var body: some View {
        Group {
            if isActive {
                MainTabViewCoulson()
            } else {
                ZStack {
//                    Color.white.ignoresSafeArea()
                    Color("SplashColor").ignoresSafeArea()
                    
                    if let _ = UIImage(named: "PureProfitSplash") {
                        Image("PureProfitSplash")
                            .resizable()
                            .scaledToFit()
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .frame(width: 120, height: 120)
                            /*
                             비율 유지하며 전체 보이게    .scaledToFit().ignoresSafeArea()
                             꽉 채우되 잘릴 수 있음    .scaledToFill().ignoresSafeArea()
                             */
                            .ignoresSafeArea()
//                            .background(Color.black)
                    } else {
                        Text("이익봤쥬팀 수고했어요")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            isActive = true
                        }
                    }
                }
            }
        }
    }
}
