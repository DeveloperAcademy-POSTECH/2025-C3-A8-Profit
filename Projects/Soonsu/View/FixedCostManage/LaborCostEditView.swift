//
//  LaborCostEditView.swift
//  Soonsu
//
//  Created by JiJooMaeng on 6/7/25.
//

import SwiftUI

struct LaborCostEditView: View {
    @State private var employeeName: String
    @State private var employeeTime: String
    @State private var employeeSalary: String
    @State private var isModified: Bool = false

    var labor: TempLaborCost
    var onSave: (TempLaborCost) -> Void

    init(labor: TempLaborCost, onSave: @escaping (TempLaborCost) -> Void, onCancel: @escaping () -> Void) {
        self.labor = labor
        self.onSave = onSave
        _employeeName = State(initialValue: labor.employeeName)
        _employeeTime = State(initialValue: String(labor.employeeTime))
        _employeeSalary = State(initialValue: String(labor.employeeSalary))
    }

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                Text("직원 수정")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)

                VStack(alignment: .leading) {
                    Text("알바생 이름")
                    TextField("홍길동", text: $employeeName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(6)
                        .onChange(of: employeeName) { _ in checkIfModified() }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)

                VStack(alignment: .leading) {
                    Text("근무 시간")
                    TextField("24", text: $employeeTime)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(6)
                        .onChange(of: employeeTime) { _ in checkIfModified() }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)

                VStack(alignment: .leading) {
                    Text("시급")
                    TextField("10,030", text: $employeeSalary)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(6)
                        .onChange(of: employeeSalary) { _ in checkIfModified() }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)

                Spacer()

                HStack {

                    Button {
                        if let time = Int(employeeTime), let salary = Int(employeeSalary) {
                            var edited = labor
                            edited.employeeName = employeeName
                            edited.employeeTime = time
                            edited.employeeSalary = salary
                            onSave(edited)
                        }
                    } label: {
                        Text("직원 수정")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(isModified ? Color.blue : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(!isModified)
                }
            }
            .padding(16)
            .navigationTitle("인건비 수정")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func checkIfModified() {
        isModified = employeeName != labor.employeeName ||
                     employeeTime != String(labor.employeeTime) ||
                     employeeSalary != String(labor.employeeSalary)
    }
}


#if DEBUG
struct LaborCostEditView_Previews: PreviewProvider {
    static var previews: some View {
        let sample = TempLaborCost(
            employeeName: "홍길동",
            employeeTime: 40,
            employeeSalary: 10000
        )
        return NavigationStack {
            LaborCostEditView(labor: sample, onSave: { _ in }, onCancel: {})
        }
    }
}
#endif
