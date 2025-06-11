//
//  LaborCostAddView.swift
//  Soonsu
//
//  Created by JiJooMaeng on 6/5/25.
//

import SwiftUI

struct LaborCostAddView: View {
    @State private var employeeName: String = ""
    @State private var employeeTime: String = ""
    @State private var employeeSalary: String = ""
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    
    var onAdd: (TempLaborCost) -> Void
    
    private var isFormValid: Bool {
        !employeeName.isEmpty && !employeeTime.isEmpty && !employeeSalary.isEmpty
    }
    
    enum Field: Hashable {
        case name
        case time
        case salary
    }
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading) {
                        Text("알바생 이름")
                        TextField("홍길동", text: $employeeName)
                            .focused($focusedField, equals: .name)
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
                            .focused($focusedField, equals: .time)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(6)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    
                    VStack(alignment: .leading) {
                        Text("시급")
                        TextField("10,030", text: $employeeSalary)
                            .focused($focusedField, equals: .salary)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(6)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    
                    Spacer()
                    
                    Button {
                        guard let time = Int(employeeTime),
                              let salary = Int(employeeSalary) else { return }
                        let labor = TempLaborCost(
                            employeeName: employeeName,
                            employeeTime: time,
                            employeeSalary: salary
                        )
                        onAdd(labor)
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
                .navigationTitle("인건비 추가")
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
                if focusedField != nil {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            focusedField = nil
                        }
                }
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}

    #Preview {
        NavigationStack {
            LaborCostAddView { _ in }
        }
    }
