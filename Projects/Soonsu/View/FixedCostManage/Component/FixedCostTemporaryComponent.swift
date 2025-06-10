//
//  FixedCostTemporaryComponent.swift
//  Soonsu
//
//  Created by JiJooMaeng on 6/5/25.
//
/*
 FixedCostEditor 에서 변형하였습니다!!
 */

import SwiftUI
import SwiftData

/// 매월 고정비를 입력·저장할 수 있는 박스
struct FixedCostTemporaryComponent: View {
    @ObservedObject var vm: ProfitViewModel
    @State private var inputCost: String = ""
    @State private var inputDays: String = ""
    @State private var saveMsg: String = ""
    @State private var refreshTrigger = false
    @State private var totalFixed: Int = 0
    @State private var dailyFixed: Int = 0
    @State private var displayedOperatingDays: Int = 0
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<FixedCostTemporary>(sortBy: [SortDescriptor(\FixedCostTemporary.date, order: .reverse)]))
    private var temporaries: [FixedCostTemporary]
    //키보드 숨기기
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
            case cost, days
        }
    
    private var isInputValid: Bool {
        if let num = Int(inputCost), num > 0,
           let days = Int(inputDays), days > 0 {
            return true
        }
        return false
    }
    
    var latestTemporary: FixedCostTemporary? {
        temporaries.first
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("임시 고정비")
                .padding(.bottom, 15)
            
            HStack {
                Text("총 고정비")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Text("-\(self.totalFixed) 원")
                    .foregroundColor(.red)
                    .font(.title2)
                    .fontWeight(.bold)
            }
//            .padding(.bottom, 16)
            
            HStack {
                Text("하루 고정비")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Text("- \(self.dailyFixed.formatted(.number.grouping(.automatic))) 원")
                    .foregroundColor(.red)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Divider()
                .padding(.bottom, 12)
            
            VStack(alignment: .leading) {
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
        .cornerRadius(16)
        .onChange(of: temporaries) { _ in
            print("Temporary fixed cost updated. UI will refresh.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let latest = temporaries.first {
                    totalFixed = latest.monthlyFixedCost
                    dailyFixed = latest.operatingDays > 0 ? latest.monthlyFixedCost / latest.operatingDays : 0
                    displayedOperatingDays = latest.operatingDays
                } else {
                    totalFixed = vm.monthlyFixedCost
                    dailyFixed = vm.operatingDays > 0 ? vm.monthlyFixedCost / vm.operatingDays : 0
                    displayedOperatingDays = vm.operatingDays
                }
            }
        }
        .onAppear {
            if let latest = temporaries.first {
                totalFixed = latest.monthlyFixedCost
                dailyFixed = latest.operatingDays > 0 ? latest.monthlyFixedCost / latest.operatingDays : 0
                displayedOperatingDays = latest.operatingDays
            } else {
                totalFixed = vm.monthlyFixedCost
                dailyFixed = vm.operatingDays > 0 ? vm.monthlyFixedCost / vm.operatingDays : 0
                displayedOperatingDays = vm.operatingDays
            }
        }
        .task {
            if let latest = temporaries.first {
                totalFixed = latest.monthlyFixedCost
                dailyFixed = latest.operatingDays > 0 ? latest.monthlyFixedCost / latest.operatingDays : 0
                displayedOperatingDays = latest.operatingDays
            } else {
                totalFixed = vm.monthlyFixedCost
                dailyFixed = vm.operatingDays > 0 ? vm.monthlyFixedCost / vm.operatingDays : 0
                displayedOperatingDays = vm.operatingDays
            }
        }
        
        
        
        VStack(alignment: .leading, spacing: 8) {
            Text("임시 고정비")
                .font(.headline)
            HStack {
                HStack {
                    TextField("총 고정비", text: $inputCost)
                        .keyboardType(.numberPad)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    Text("만원")
                        .foregroundColor(.gray)
                }
                HStack {
                    TextField("영업일수", text: $inputDays)
                        .keyboardType(.numberPad)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    Text("일")
                        .foregroundColor(.gray)
                }
            }
            Button {
                if let num = Int(inputCost), num >= 0,
                   let days = Int(inputDays), days > 0   {
                    let newTemporary = FixedCostTemporary(
                        date: vm.selectedDate,
                        monthlyFixedCost: num * 10_000,
                        operatingDays: days
                    )
                    modelContext.insert(newTemporary)
                    print("Saved temporary fixed cost: \(newTemporary.monthlyFixedCost), days: \(newTemporary.operatingDays), date: \(String(describing: newTemporary.date))")
                    inputCost = ""
                    inputDays = ""
                    saveMsg = "고정비가 저장되었습니다."
                    refreshTrigger.toggle()
                    totalFixed = newTemporary.monthlyFixedCost
                    dailyFixed = newTemporary.operatingDays > 0 ? newTemporary.monthlyFixedCost / newTemporary.operatingDays : 0
                    displayedOperatingDays = newTemporary.operatingDays
                    try? modelContext.save()
                } else {
                    saveMsg = "유효한 금액과 영업일수를 입력하세요."
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+1.2) {
                    saveMsg = ""
                }
            } label: {
                Text("저장")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(isInputValid ? Color.blue : Color.gray)
                    .cornerRadius(6)
                    .font(.headline)
            }
            .padding(.top, 3)
            .disabled(!isInputValid)
            
            Text("마지막 업데이트: \(koreaDateFormatter.string(from: vm.lastFixedCostUpdate))")
                .font(.caption2)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .center)
            Text("고정비는 매월 초 또는 변경 시 한 번만 입력하시면 됩니다.")
                .font(.caption2)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .center)
            if !saveMsg.isEmpty {
                Text(saveMsg)
                    .font(.caption)
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(7)
    }
}

#Preview {
    // ProfitViewModel을 초기화하여 미리보기에 전달
    FixedCostTemporaryComponent(vm: ProfitViewModel())
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color(.systemGray6).ignoresSafeArea())
}
