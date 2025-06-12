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
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.bottom, 16)
                    
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
                    .padding(.bottom,2)
                    
                    HStack {
                        Text("하루 고정비")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.gray)
                        Spacer()
                        Text("-\(dailyFixed.formatted(.number.grouping(.automatic)))원")
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
//                .padding(.bottom, -12)
                
                
                VStack {
                    NavigationLink(destination: LaborCostManageView()) {
                        HStack {
                            Text("인건비 입력하기")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.gray.opacity(0.4))
                        }
                        .padding(20)
                        .frame(height: 64)
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 16)
//                    .padding(.top, 14)
                    
                    NavigationLink(destination: OverheadCostManageView()) {
                        HStack {
                            Text("간접비 입력하기 (⚠️공사중🚧)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.gray.opacity(0.4))
                        }
                        .padding(20)
                        .frame(height: 64)
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("이번달 영업일수")
                        .font(.headline)
                        .fontWeight(.bold)
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
                        .padding(.top,4)
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
                            .cornerRadius(12)
                            .font(.headline)
                    }
                    .disabled(!isInputValid)
                    .background(isInputValid ? Color.primaryColor700 : Color.gray)
                    .cornerRadius(6)
                    .padding(.top, 8)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)
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
