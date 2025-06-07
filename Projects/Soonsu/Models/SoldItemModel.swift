//
//  SoldItemModel.swift
//  Soonsu
//
//  Created by coulson on 6/5/25.
//

import Foundation
import SwiftData

@Model
class SoldItemModel {
    var id: Int
    var name: String
    var price: Int
    var qty: Int
    var image: String
    var parentDate: String
    
    init(id: Int, name: String, price: Int, qty: Int, image: String, parentDate: String) {
        self.id = id
        self.name = name
        self.price = price
        self.qty = qty
        self.image = image
        self.parentDate = parentDate
    }
    var toSoldItem: SoldItem {
        .init(id: id, name: name, price: price, qty: qty, image: image)
    }
}
