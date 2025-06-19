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
                .padding(.bottom)
                .padding(.top, -8)
                .foregroundStyle(Color.neutral400)
            

            Chart {
                ForEach(Array(dummyData.enumerated()), id: \.offset) { index, value in
                    LineMark(
                        x: .value("Day", "6/\(index + 1)"),
                        y: .value("Profit", value)
                    )
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(height: 180)
            .chartYAxis {
            AxisMarks(stroke: StrokeStyle(lineWidth: 0))
            }
            .chartXAxis {
            AxisMarks(stroke: StrokeStyle(lineWidth: 0))
            }

        }
        .padding()
        .padding(.vertical)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 12)
    }
}
