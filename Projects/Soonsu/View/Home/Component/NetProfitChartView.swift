//
//  NetProfitChartView.swift
//  Soonsu
//
//  Created by coulson on 6/19/25.
//
import SwiftUI
import Charts

struct NetProfitChartView: View {
    let dummyData: [Int] = [100000, 180000, 140000, 120000, 160000]

    var body: some View {
        VStack(alignment: .leading) {
            Text("순수익 변화")
                .font(.headline)

            Chart {
                ForEach(Array(dummyData.enumerated()), id: \.offset) { index, value in
                    LineMark(
                        x: .value("Day", "6월 \(index + 1)일"),
                        y: .value("Profit", value)
                    )
                }
            }
            .frame(height: 180)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}
