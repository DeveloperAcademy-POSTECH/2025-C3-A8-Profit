//
//  Cost.swift
//  Soonsu
//
//  Created by Choi Jung In on 6/3/25.
//

import Foundation

struct Cost: Identifiable, Codable {
    var id: UUID = UUID()
    
    var rent: Int               // 임차료
    var salary: Int             // 급여
    var insurance: Int          // 보험료
    var depreciation: Int       // 감가상각비
    var communication: Int      // 통신비
    var utilities: Int          // 공과금
    
    // 총합 계산
    var total: Int {
        rent + salary + insurance + depreciation + communication + utilities
    }
}
