//
//  User.swift
//  Soonsu
//
//  Created by Choi Jung In on 6/3/25.
//

import Foundation

struct User: Identifiable, Codable {
    var id: UUID = UUID()              // 고유 식별자
    var storeName: String              // 가게 이름
    var businessHours: String          // 영업시간 (예: "09:00 - 18:00")
    var businessDays: String       // 영업일수 (예: ["Mon", "Tue", "Wed", "Thu", "Fri"])
}
