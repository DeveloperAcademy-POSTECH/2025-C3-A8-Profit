//
//  OverheadBasicView.swift
//  Soonsu
//
//  Created by JiJooMaeng on 6/8/25.
//

import SwiftUI
import SwiftData

struct OverheadBasicView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    private enum Field: Hashable {
        case amount
    }

    var category: OverheadCategory

    @Binding var tempCosts: [(OverheadCost, BasicCost)]

    @State private var amountString: String = ""
    @State private var showInfoSheet = false

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 24) {
                Text("매달 지불하는 \(category.rawValue)를(을) 입력해 주세요.")
                    .font(.subheadline)
                
                VStack(alignment: .leading) {
                    Text("월 \(category.rawValue)")
                        .font(.subheadline)
                        .bold()
                    
                    HStack {
                        TextField("금액을 입력해 주세요", text: $amountString)
                            .focused($focusedField, equals: .amount)
                            .keyboardType(.numberPad)
                            .padding(12)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                        
                        Text("원")
                            .font(.subheadline)
                            .padding(.leading, 4)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                
                Spacer()
                
                Button(action: save) {
                    Text("\(category.rawValue) 등록")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(isValidAmount ? Color.accentColor : Color.gray.opacity(0.5))
                        .cornerRadius(8)
                }
                .disabled(!isValidAmount)
            }
            .padding()
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 4) {
                        Text(category.rawValue)
                            .font(.headline)
                        Button {
                            showInfoSheet = true
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundStyle(.black)
                        }
                    }
                }
            }
            if focusedField != nil {
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                focusedField = nil
                            }
                    }
        }
        .sheet(isPresented: $showInfoSheet) {
            VStack(spacing: 32) {
                Text("계산식 안내")
                    .font(.headline)
                    .padding(.top)
                

                Text(infoText(for: category))
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Spacer()
            }
            .padding()
            .presentationDetents([.fraction(0.2)])
            .presentationDragIndicator(.visible)
        }
    }

    private func save() {
        guard let amount = Int(amountString) else { return }
        let overhead = OverheadCost(category: category)
        let basic = BasicCost(overheadCost: overhead, amount: amount)
        tempCosts.append((overhead, basic))
        dismiss()
    }

    private var isValidAmount: Bool {
        Int(amountString) != nil
    }
    
    private func infoText(for category: OverheadCategory) -> String {
        switch category {
        case .rent: return "임차료 : 월 임차료"
        case .tax: return "공과금(주민세 등) : 연간 비용 / 12"
        case .internet: return "인터넷/통신비 : 월 인터넷/통신비"
        case .insurance: return "보험료(화재보험, 산재보험 등) : 월 보험총액"
        case .supply: return "소모품비 : 월 총비용"
        case .advertising: return "광고비(온,오프라인 광고) : 월 총비용"
        case .depreciation: return "감가상각비(설비, 시설비): (최초구매가 - 예상잔존가치) / (예상사용년수 × 12개월)"
        case .utilities: return "수도광열비(전기,수도,가스): 각 월 총비용"
        case .rental: return "렌탈료: 항목별 총 렌탈료"
        case .interest: return "이자비용: 월 이자비용 총액"
        case .etc: return "기타/잡비: 월 총비용"
        }
    }
}

#Preview {
    NavigationStack {
        OverheadBasicView(category: .rent, tempCosts: .constant([]))
    }
}
