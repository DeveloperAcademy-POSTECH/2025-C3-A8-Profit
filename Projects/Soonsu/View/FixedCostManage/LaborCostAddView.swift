//
//  LaborCostAddView.swift
//  Soonsu
//
//  Created by JiJooMaeng on 6/5/25.
//

import SwiftUI
import SwiftData

struct LaborCostAddView: View {
    @State private var employeeName: String = ""
    @State private var employeeTime: String = ""
    @State private var employeeSalary: String = ""
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    private var isFormValid: Bool {
        !employeeName.isEmpty && !employeeTime.isEmpty && !employeeSalary.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("직원 등록")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.bottom, 20)

                    VStack(alignment: .leading) {
                        Text("알바생 이름")
                        TextField("홍길동", text: $employeeName)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(6)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)

                    VStack(alignment: .leading) {
                        Text("근무 시간")
                        TextField("24", text: $employeeTime)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(6)
                            .keyboardType(.numberPad)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)

                    VStack(alignment: .leading) {
                        Text("시급")
                        TextField("10,030", text: $employeeSalary)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(6)
                            .keyboardType(.numberPad)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)

                Spacer()
                
                
                Button {
                    guard let time = Int(employeeTime), let salary = Int(employeeSalary) else {
                        return
                    }
                    let newLabor = LaborCost(employeeName: employeeName, employeeTime: time, employeeSalary: salary)
                    modelContext.insert(newLabor)
                    
                    // 초기화 또는 화면 종료는 필요에 따라 추가 가능
                    employeeName = ""
                    employeeTime = ""
                    employeeSalary = ""
                    
                    dismiss()
                } label: {
                    Text("직원 등록")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(isFormValid ? Color.blue : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(!isFormValid)

            }
            .padding(16)
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("인건비 추가")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

#Preview {
    LaborCostAddView()
}
