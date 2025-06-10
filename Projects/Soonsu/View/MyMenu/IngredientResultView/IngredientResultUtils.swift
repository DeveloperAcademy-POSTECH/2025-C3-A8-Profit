//
//  IngredientResultUtils.swift
//  Soonsu
//
//  Created by Choi Jung In on 6/11/25.
//

import Foundation


func splitContentIntoAmountAndUnit(text: String) -> (String, String) {
        var newAmountString: String = "" // 임시 변수
        var newUnitString: String = ""   // 임시 변수

        for char in text {
            if char.isNumber {
                newAmountString.append(char)
            } else {
                newUnitString.append(char)
            }
        }
    
    return (newAmountString, newUnitString)
}
