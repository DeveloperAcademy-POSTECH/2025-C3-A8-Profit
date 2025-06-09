//
//  MenuItem.swift
//  Soonsu
//
//  Created by coulson on 6/2/25.
//

import Foundation


/// ‘메뉴 목록’의 기본 구조체
struct MenuItem: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let price: Int
    let materialCostPerUnit: Int
//    let materialCostPerUnit: Double
    let image: String
}
