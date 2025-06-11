//
//  LaborCostManage.swift
//  Soonsu
//
//  Created by JiJooMaeng on 6/5/25.
//

import SwiftUI
import SwiftData

struct TempLaborCost: Identifiable {
    let id = UUID()
    var employeeName: String
    var employeeTime: Int
    var employeeSalary: Int
}

struct LaborCostManageView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var tabBarState: TabBarState
    @Query private var savedLabors: [LaborCost]
    @State private var showAddEmployee = false
    @State private var laborCosts: [TempLaborCost] = []
    @State private var isModified: Bool = false
    @State private var didLoad: Bool = false
    
    
    @State private var selectedLabor: TempLaborCost? = nil
    @State private var showEditView: Bool = false
    @FocusState private var focusedField: Field?
    
    private func loadLaborCosts() {
        do {
            // 단순한 fetch로 변경
            let descriptor = FetchDescriptor<LaborCost>()
            let results = try modelContext.fetch(descriptor)

            print("🔍 불러온 인건비 개수: \(results.count)")
            for result in results {
                print("👤 \(result.employeeName), \(result.employeeTime)시간, \(result.employeeSalary)원")
            }

            laborCosts = results.map { labor in
                TempLaborCost(
                    employeeName: labor.employeeName,
                    employeeTime: labor.employeeTime,
                    employeeSalary: labor.employeeSalary
                )
            }

            isModified = false
        } catch {
            print("❌ Failed to fetch LaborCosts: \(error)")
        }
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
            
            VStack {
                
                if laborCosts.isEmpty {
                    Spacer()
                    Text("등록된 인건비가 없습니다.")
                        .font(.body)
                        .fontWeight(.regular)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(laborCosts) { labor in
                            Button {
                                selectedLabor = labor
                                showEditView = true
                            } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .frame(width: 33, height: 33)
                                            .foregroundColor(.black)
                                        VStack(alignment: .leading) {
                                            Text(labor.employeeName)
                                                .foregroundStyle(.black)
                                                .font(.caption)
                                                .fontWeight(.bold)
                                            Text("월 \(labor.employeeTime)시간 * 시급 \(labor.employeeSalary.formatted())원")
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Text("월 \((labor.employeeTime * labor.employeeSalary).formatted())원")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .frame(minHeight: 60)
                            }
                        }
                        .onDelete { indexSet in
                            laborCosts.remove(atOffsets: indexSet)
                            isModified = true
                        }
                    }
                    .padding(.horizontal, -16)

                }
                
                let totalHours = laborCosts.reduce(0) { $0 + $1.employeeTime }
                let totalCost = laborCosts.reduce(0) { $0 + ($1.employeeTime * $1.employeeSalary) }
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    HStack {
                        Text("월 총 근무시간")
                            .font(.headline)
                        Spacer()
                        Text("\(totalHours) 시간")
                            .font(.headline)
                    }
                    
                    HStack {
                        Text("월 총 인건비")
                            .font(.headline)
                        Spacer()
                        Text("\(totalCost.formatted()) 원")
                            .font(.headline)
                    }
                }
                .padding(.top)
                
                Button("인건비 등록") {
                    do {
                        let existing = try modelContext.fetch(FetchDescriptor<LaborCost>())
                        
                        for item in existing {
                            modelContext.delete(item)
                        }
                        
                        for temp in laborCosts {
                            let newLabor = LaborCost(
                                employeeName: temp.employeeName,
                                employeeTime: temp.employeeTime,
                                employeeSalary: temp.employeeSalary,
                                createdAt: Date()
                            )
                            modelContext.insert(newLabor)
                        }
                        
                        try modelContext.save()
                        
                        loadLaborCosts()
                        
                        isModified = false
                    } catch {
                        print("Failed to save LaborCosts: \(error)")
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(isModified ? Color.blue : Color.gray)
                .cornerRadius(10)
                .padding(.top, 8)
                .disabled(!isModified)
            }
            .padding(16)
        }
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAddEmployee = true
                } label: {
                    HStack {
                        Image(systemName: "plus")
                    }
                    .font(.headline)
                }
            }
        }
        .navigationDestination(isPresented: $showAddEmployee) {
            LaborCostAddView { newLabor in
                laborCosts.append(
                    TempLaborCost(
                        employeeName: newLabor.employeeName,
                        employeeTime: newLabor.employeeTime,
                        employeeSalary: newLabor.employeeSalary
                    )
                )
                isModified = true
            }
        }
        .navigationDestination(isPresented: $showEditView) {
            if let labor = selectedLabor {
                LaborCostEditView(
                    labor: labor,
                    onSave: { edited in
                        if let index = laborCosts.firstIndex(where: { $0.id == edited.id }) {
                            laborCosts[index] = edited
                            isModified = true
                        }
                        showEditView = false
                    },
                    onCancel: {
                        showEditView = false
                    }
                )
            }
            
        }
        .onChange(of: showEditView) { _, newValue in
            // no action needed
        }
        
        .navigationTitle(Text("인건비 관리"))
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
        .onAppear {
            if !didLoad {
                loadLaborCosts()
                didLoad = true
            }
            tabBarState.isVisible = false
        }
        // Remove onDisappear to prevent tab bar from reappearing when this view disappears
        // .onDisappear {
        //     tabBarState.isVisible = true
        // }
        //            .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    NavigationStack {
        LaborCostManageView()
            .environmentObject(TabBarState())
    }
}
