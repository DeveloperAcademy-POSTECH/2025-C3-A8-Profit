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

/// 매월 고정비를 입력·저장할 수 있는 박스
struct FixedCostTemporaryComponent: View {
    @ObservedObject var vm: ProfitViewModel
    @State private var inputCost: String = ""
    @State private var inputDays: String = ""
    @State private var saveMsg: String = ""
    
    //키보드 숨기기
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
            case cost, days
        }
    
    var body: some View {
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
                    vm.monthlyFixedCost = num * 10_000   // 만원 → 원
                    vm.operatingDays    = days
                    vm.lastFixedCostUpdate = Date()
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
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("완료") {
                    focusedField = nil // SwiftUI 방식 키보드 숨기기
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
