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
            Text("안녕하세요, 누나함박님!")
                .font(.title3)
                .fontWeight(.bold)

            Text("6월 현재까지의 평균 순수익은 ")
            + Text("120,000원")
                .foregroundColor(.blue)
                .fontWeight(.semibold)
            + Text(" 입니다.")
        }
    }
}
