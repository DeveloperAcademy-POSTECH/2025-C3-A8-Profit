//
//  DailyProfitSummary.swift
//  Soonsu
//
//  Created by coulson on 6/3/25.
//

import SwiftUI

/// 선택된 날짜의 세부 매출·원가·순이익 요약
struct DailyProfitSummary: View {
    @ObservedObject var vm: ProfitViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            if let sales = vm.salesData(for: vm.selectedDate) {
                let dailyFixed = vm.dailyFixedCost(for: vm.selectedDate)
                let net = sales.revenue - Int(sales.materialCost) - dailyFixed
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(DateFormatter.korMonthDay.string(from: vm.selectedDate)) " +
                         "\(vm.weekdayKorean(vm.selectedDate))요일 순이익")
                        .font(.headline)
                        .padding(.top, 6)
                
                    let netString = "\(net > 0 ? "+" : "-")\(abs(net).formatted(.number.grouping(.automatic))) 원"
                    Text(netString)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(net > 0 ? .blue : .red)
                        .padding(.bottom, 2)
                    HStack {
                        Text("매출:")
                        Spacer()
                        Text("+ \(sales.revenue.formatted(.number.grouping(.automatic))) 원")
                            .foregroundColor(.green)
                    }
                    HStack {
                        Text("재료비:")
                        Spacer()
                        Text("- \(sales.materialCost.formatted(.number.grouping(.automatic))) 원")
                            .foregroundColor(.red)
                    }
                    HStack {
                        Text("고정비 (일할):")
                        Spacer()
                        Text("- \(dailyFixed.formatted(.number.grouping(.automatic))) 원")
                            .foregroundColor(.red)
                    }
                    if !vm.isFixedCostSet {
                        Text("※ 기본 고정비 300만원(일할 \(dailyFixed.formatted(.number.grouping(.automatic)))원) 기준입니다.")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                .font(.system(size: 15, weight: .medium))
                
                Button {
                    vm.showSalesInputSheet = true
                } label: {
                    Text("판매량 수정")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .foregroundColor(.gray)
                        .cornerRadius(10)
                        .font(.headline)
                }
                
                Button {
                    vm.showTips.toggle()
                } label: {
                    HStack {
                        Text("✨ 오늘의 경영 팁 보기")
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.headline)
                }
                .padding(.top, 2)
                
                if vm.showTips {
                    Text("오늘의 경영 팁(여기에 AI 연동 예정!)")
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(10)
                        .font(.subheadline)
                        .foregroundColor(.purple)
                }
            } else {
                let dailyFixed = vm.dailyFixedCost(for: vm.selectedDate)
                
                
                VStack() {
                    if !vm.isFixedCostSet {
                        HStack {
                            Text("※ 임시 고정비 300만원(일할 \(dailyFixed.formatted(.number.grouping(.automatic)))원) 기준입니다.")
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .padding(.vertical,4)
                            
                            Spacer()
                        }
                    }
                    HStack {
                        Text("고정비(일별)")
                            .padding(.trailing, 8)
                            .font(.headline)
                        Spacer()
                        Text("-\(dailyFixed.formatted(.number.grouping(.automatic)))원")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                    Button {
                        vm.showSalesInputSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("판매량 입력")
                        }
                        .frame(width: 140, height: 56)
                        .background(Color.primaryColor700)
                        .foregroundColor(.white)
                        .cornerRadius(28)
                        .font(.headline)
                    }
                    .padding(.top, 8)
                    .padding(.trailing,-8)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .background(Color.white)
            }
        }
        .padding(.vertical)
        .padding(.bottom, 8)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    DailyProfitSummary(vm: ProfitViewModel())
}
