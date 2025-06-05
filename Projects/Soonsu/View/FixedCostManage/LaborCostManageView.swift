//
//  LaborCostManage.swift
//  Soonsu
//
//  Created by JiJooMaeng on 6/5/25.
//

import SwiftUI
import SwiftData

struct LaborCostManageView: View {
    @State private var showAddEmployee = false
    @Query var laborCosts: [LaborCost]
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("인건비")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Button {
                        showAddEmployee = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                }
                
                if laborCosts.isEmpty {
                    Spacer()
                    Text(
                        """
                        인건비를 추가해서 총 고정비를
                        파악해보세요
                        """
                    )
                    .font(.body)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
                    .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(laborCosts) { labor in
                            VStack(alignment: .leading) {
                                Text(labor.employeeName)
                                    .font(.headline)
                                Text("근무시간: \(labor.employeeTime)시간, 시급: \(labor.employeeSalary)원")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 8)
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.white)
                }
                
            }
            
            .navigationDestination(isPresented: $showAddEmployee) {
                LaborCostAddView()
            }
            .padding(16)
            .navigationTitle(Text("인건비 관리"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    print("tap!")
                } label: {
                    Text("저장")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        LaborCostManageView()
    }
}
