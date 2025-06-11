//
//  FixedCostDetailView.swift
//  Soonsu
//
//  Created by JiJooMaeng on 6/5/25.
//

import SwiftUI
import SwiftData

struct FixedCostDetailView: View {
    @ObservedObject var vm: ProfitViewModel
    @Environment(\.modelContext) private var context
    @Query(sort: [SortDescriptor(\FixedCostTemporary.date, order: .reverse)])
    private var savedFixedCosts: [FixedCostTemporary]
    @FocusState private var focusedField: Field?
    
    @State private var totalFixedCost: String = ""
    @State private var inputDays: String = ""
    @State private var displayedOperatingDays: Int = 0
    
    @Query private var savedLabors: [LaborCost]
    
    private enum Field: Hashable {
        case days
    }

    private var isInputValid: Bool {
        Int(inputDays) ?? 0 > 0
    }
    
    var body: some View {
        let dailyFixed = vm.dailyFixedCost(for: vm.selectedDate)
        let totalFixed = vm.monthlyFixedCost
        
        
        ZStack {
            VStack {
                VStack(alignment: .leading) {
                    Text("상세 고정비")
                        .padding(.bottom, 15)
                    
                    HStack {
                        Text("총 고정비")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.gray)
                        Spacer()
                        Text("-\(totalFixed)원")
                            .foregroundColor(.red)
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        Text("하루 고정비")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.gray)
                        Spacer()
                        Text("- \(dailyFixed.formatted(.number.grouping(.automatic))) 원")
                            .foregroundColor(.red)
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    
                    Divider()
                        .padding(.bottom, 12)
                    
                    let totalCost = savedLabors.reduce(0) { $0 + ($1.employeeTime * $1.employeeSalary) }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("인건비")
                            Spacer()
                            Text("\(totalCost.formatted())원")
                        }
                        
                        HStack {
                            Text("간접비")
                            Spacer()
                            Text("1,500,000원")
                        }
                        
                        HStack {
                            Text("영업일수")
                            Spacer()
                            Text("\(displayedOperatingDays != 0 ? displayedOperatingDays : vm.operatingDays)일")
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)
                
                
                VStack {
                    NavigationLink(destination: LaborCostManageView()) {
                        HStack {
                            Text("인건비 입력하기")
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding(20)
                        .frame(height: 41)
                        .background(Color.white)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 14)
                    
                    NavigationLink(destination: OverheadCostManageView()) {
                        HStack {
                            Text("간접비 입력하기 (⚠️공사중🚧)")
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding(20)
                        .frame(height: 41)
                        .background(Color.white)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal, 16)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("이번달 영업일수")
                        .font(.caption)
                    HStack {
                        
                        HStack {
                            TextField("영업일수", text: $inputDays)
                                .focused($focusedField, equals: .days)
                                .keyboardType(.numberPad)
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            Text("일")
                                .foregroundColor(.gray)
                        }
                    }
                    Button {
                        if let days = Int(inputDays), days > 0 {
                            let newTemporary = FixedCostTemporary(
                                date: vm.selectedDate,
                                monthlyFixedCost: vm.monthlyFixedCost,
                                operatingDays: days
                            )
                            context.insert(newTemporary)
                            try? context.save()
                            displayedOperatingDays = days
                            inputDays = ""
                        }
                    } label: {
                        Text("저장")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .cornerRadius(6)
                            .font(.headline)
                    }
                    .disabled(!isInputValid)
                    .background(isInputValid ? Color.blue : Color.gray)
                    .cornerRadius(6)
                    .padding(.top, 3)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(7)
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground))
            
            if focusedField != nil {
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                focusedField = nil
                            }
                    }

        }
    }
}


#Preview {
    FixedCostDetailView(vm: ProfitViewModel())
}
