//
//  HomeDashboardView.swift
//  Soonsu
//
//  Created by coulson on 6/19/25.
//

import SwiftUI

struct HomeDashboardView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                greetingSection
                NetProfitChartView()
                RetailPriceSectionView()
            }
            .padding()
            
        }
        .navigationTitle("홈")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var greetingSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Spacer()
                .frame(height: 32)
            Group {
                Text("안녕하세요, 누나함박님!")
                    .padding(.bottom)
                    .foregroundStyle(Color.neutral400)
                
                Text("6월 평균 순수익은 ")
                Text("120,000원")
                    .foregroundStyle(Color.primary700)

                + Text("입니다.")
            }
            .font(.title)
            .fontWeight(.bold)
        }
        
    }
}

#Preview {
    HomeDashboardView()
}
