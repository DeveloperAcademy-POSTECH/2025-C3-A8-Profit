//
//  IngredientAddUtils.swift
//  Soonsu
//
//  Created by Choi Jung In on 6/8/25.
//
import Foundation


func loadAllIngredientsFromJSON() -> [IngredientInfo] {
    let fileNames = ["IngredientsKamis", "IngredientsCham"]
    var results: [IngredientInfo] = []

    for file in fileNames {
        if let url = Bundle.main.url(forResource: file, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoded = try JSONDecoder().decode([IngredientInfo].self, from: data)
                results.append(contentsOf: decoded)
            } catch {
                print("❌ Failed to load \(file): \(error)")
            }
        } else {
            print("❌ File not found: \(file)")
        }
    }

    return results
}
