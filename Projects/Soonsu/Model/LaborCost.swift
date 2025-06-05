//
//  LaborCost.swift
//  Soonsu
//
//  Created by JiJooMaeng on 6/5/25.
//


import Foundation
import SwiftData

@Model
class LaborCost {
    var employeeName: String
    var employeeTime: Int
    var employeeSalary: Int
    var createdAt: Date

    init(employeeName: String, employeeTime: Int, employeeSalary: Int, createdAt: Date = Date()) {
        self.employeeName = employeeName
        self.employeeTime = employeeTime
        self.employeeSalary = employeeSalary
        self.createdAt = createdAt
    }

    var totalWage: Int {
        return employeeTime * employeeSalary
    }
}
