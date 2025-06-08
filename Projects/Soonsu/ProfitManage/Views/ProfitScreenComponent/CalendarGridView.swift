//
//  CalendarGridView.swift
//  Soonsu
//
//  Created by coulson on 6/3/25.
//

import SwiftUI

/// 월별 달력 그리드 + 일별 순이익을 보여주는 뷰
struct CalendarGridView: View {
    @ObservedObject var vm: ProfitViewModel
    
    
    private let monthYearFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR_POSIX")
        df.dateFormat = "yyyy년 M월"
        return df
    }()
    
    var body: some View {
        let month = vm.currentMonth
        let year = Calendar.current.component(.year, from: month)
        let monthNum = Calendar.current.component(.month, from: month)
        let headerTitle = monthYearFormatter.string(from: vm.currentMonth)
        
        VStack(spacing: 0) {
            // 상단 월 전환 버튼 + 타이틀
            HStack {
                Button {
                    vm.currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: vm.currentMonth)!
                } label: {
                    Image(systemName: "chevron.left")
                        .padding(8)
                }
                Spacer()
                Text(headerTitle)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                Spacer()
                Button {
                    vm.currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: vm.currentMonth)!
                } label: {
                    Image(systemName: "chevron.right")
                        .padding(8)
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 2)
            
            // 요일 헤더
            HStack {
                ForEach(["일","월","화","수","목","금","토"], id: \.self) { d in
                    Text(d)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                        .font(.system(size: 14, weight: .medium))
                }
            }
            .padding(.bottom, 2)
            
            // 날짜 셀 그리드
            let days = daysInMonth(for: month)
            let firstWeekday = Calendar.current.component(.weekday, from: firstDay(of: month))
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                // 달력 앞부분 빈 칸
                ForEach(0..<firstWeekday-1, id: \.self) { _ in
                    Color.clear.frame(height: 38)
                }
                // 1~말일 날짜 셀
                ForEach(1...days, id: \.self) { day in
                    let date = dayDate(year: year, month: monthNum, day: day)
                    let isSelected = Calendar.current.isDate(date, inSameDayAs: vm.selectedDate)
                    let netProfit = vm.netProfit(for: date)
                    VStack(spacing: 1) {
                        Text("\(day)")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(isSelected ? .white : .primary)
                        if let profit = netProfit {
                            let profitStr = "\(profit > 0 ? "+" : "-")\(vm.shortCurrency(abs(profit)))"
                            Text(profitStr)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(isSelected ? .white.opacity(0.7) : (profit > 0 ? .green : .red))
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 38)
                    .background(isSelected ? Color.blue : Color.clear)
                    .cornerRadius(10)
                    .onTapGesture { vm.selectedDate = date }
                }
            }
            .padding(.vertical, 2)
        }
    }
    
    private func firstDay(of date: Date) -> Date {
        let comp = Calendar.current.dateComponents([.year, .month], from: date)
        return Calendar.current.date(from: comp)!
    }
    private func daysInMonth(for date: Date) -> Int {
        Calendar.current.range(of: .day, in: .month, for: date)!.count
    }
    private func dayDate(year: Int, month: Int, day: Int) -> Date {
        Calendar.current.date(from: DateComponents(year: year, month: month, day: day))!
    }
}

#Preview {
    CalendarGridView(vm: ProfitViewModel())
}
