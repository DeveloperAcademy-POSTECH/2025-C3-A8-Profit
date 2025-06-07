//
//  FixedCostDetailView.swift
//  Soonsu
//
//  Created by JiJooMaeng on 6/5/25.
//

import SwiftUI

struct FixedCostDetailView: View {
    @ObservedObject var vm: ProfitViewModel
    
    @State private var totalFixedCost: String = ""
    
    
    
    var body: some View {
        let dailyFixed = vm.dailyFixedCost(for: vm.selectedDate)
        let totalFixed = vm.monthlyFixedCost

        
            VStack {
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
                    
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("인건비:")
                            Spacer()
                            Text("800,000원")
                        }
                        
                        HStack {
                            Text("간접비:")
                            Spacer()
                            Text("1,500,000원")
                        }
                        
                        HStack {
                            Text("감가상각비:")
                            Spacer()
                            Text("300,000원")
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)
                
                
                VStack(spacing: 12) {
                    NavigationLink(destination: LaborCostManageView()) {
                        HStack {
                            Text("인건비 입력하기(월간)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding(20)
                        .frame(width: 360, height: 84)
                        .background(Color.white)
                        .cornerRadius(16)
                    }
                    .padding(.top, 28)
                    
                    NavigationLink(destination: OverheadCostManageView()) {
                        HStack {
                            Text("간접비 입력하기(월간)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding(20)
                        .frame(width: 360, height: 84)
                        .background(Color.white)
                        .cornerRadius(16)
                    }
                    .padding(.top, 16)
                    
                    NavigationLink(destination: Text("감가상각비 입력 화면")) {
                        HStack {
                            Text("감가상각비 입력하기")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding(20)
                        .frame(width: 360, height: 84)
                        .background(Color.white)
                        .cornerRadius(16)
                    }
                    .padding(.top, 16)
                }
                
            }
            .background(Color(UIColor.systemGroupedBackground))
    }
}


#Preview {
    FixedCostDetailView(vm: ProfitViewModel())
}
