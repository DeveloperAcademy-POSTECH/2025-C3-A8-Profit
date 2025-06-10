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
    @State private var saveMsg: String = ""
    
    //키보드 숨기기
    @FocusState private var focusedField: Field?
    
    @Environment(\.modelContext) private var context
    
    @Query private var savedFixedCosts: [FixedCostTemporary]
    
    enum Field: Hashable {
            case cost, days
        }
    
    var body: some View {
        let totalFixed = vm.tempMonthlyFixedCost ?? vm.monthlyFixedCost
        let operatingDays = vm.tempOperatingDays ?? vm.operatingDays
        let dailyFixed = operatingDays > 0 ? totalFixed / operatingDays : 0
        
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("총 고정비")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Text("-\(totalFixed) 원")
                    .foregroundColor(.red)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(.bottom, 16)
            
            HStack {
                Text("하루 고정비")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Text("- \(dailyFixed.formatted(.number.grouping(.automatic))) 원")
                    .foregroundColor(.red)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(.bottom, 27)
            
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("영업일수 :")
                    Spacer()
                    Text("\(operatingDays)일")
                }
            }
            .font(.subheadline)
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal)
            
        VStack(alignment: .leading, spacing: 8) {
            Text("임시 고정비")
                .font(.headline)
            HStack {
                HStack {
                    TextField("총 고정비", text: $vm.tempInputCost)
                        .foregroundStyle(.black)
                        .keyboardType(.numberPad)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    Text("만원")
                        .foregroundColor(.gray)
                }
                HStack {
                    TextField("영업일수", text: $vm.tempInputDays)
                        .keyboardType(.numberPad)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    Text("일")
                        .foregroundColor(.gray)
                }
            }
            Button {
                if let num = Int(vm.tempInputCost), num >= 0,
                   let days = Int(vm.tempInputDays), days > 0   {
                    vm.tempMonthlyFixedCost = num * 10_000   // 만원 → 원
                    vm.tempOperatingDays = days
                    vm.lastFixedCostUpdate = Date()
                    if let existing = savedFixedCosts.first {
                        context.delete(existing)
                    }
                    let fixedCost = FixedCostTemporary(
                        date: Date(),
                        monthlyFixedCost: vm.tempMonthlyFixedCost ?? 0,
                        operatingDays: vm.tempOperatingDays ?? 0
                                            )
                    context.insert(fixedCost)
                    do {
                        try context.save()
                        vm.tempMonthlyFixedCost = fixedCost.monthlyFixedCost
                        vm.tempOperatingDays = fixedCost.operatingDays
                        vm.lastFixedCostUpdate = fixedCost.date ?? Date()
                        vm.tempInputCost = String(fixedCost.monthlyFixedCost / 10_000)
                        vm.tempInputDays = String(fixedCost.operatingDays)
                    } catch {
                        print("🔥 저장 실패: \(error)")
                    }
                    saveMsg = "고정비가 저장되었습니다."
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
                    .background(Color.blue)
                    .cornerRadius(10)
                    .font(.headline)
            }
            .padding(.top, 3)
            
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
        .onAppear {
            
            DispatchQueue.main.async {
                print("🧾 저장된 데이터 개수: \(savedFixedCosts.count)")
                if let saved = savedFixedCosts.first {
                    print("📦 저장된 고정비: \(saved.monthlyFixedCost), \(saved.operatingDays)")
                    vm.tempMonthlyFixedCost = saved.monthlyFixedCost
                    vm.tempOperatingDays = saved.operatingDays
                    vm.lastFixedCostUpdate = saved.date ?? Date()
                    vm.tempInputCost = String(saved.monthlyFixedCost / 10_000)
                    vm.tempInputDays = String(saved.operatingDays)
                }
            }
        }
    }
}

#Preview {
    // ProfitViewModel을 초기화하여 미리보기에 전달
    FixedCostTemporaryComponent(vm: ProfitViewModel())
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color(.systemGray6).ignoresSafeArea())
}
