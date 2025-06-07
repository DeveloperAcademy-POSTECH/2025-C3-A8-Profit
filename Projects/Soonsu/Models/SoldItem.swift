//
//  SoldItem.swift
//  Soonsu
//
//  Created by coulson on 6/3/25.
//

import Foundation

/// ‘판매된 아이템’ 구조체
struct SoldItem: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let price: Int
    var qty: Int
    let image: String
}
extension SoldItem {
    func toModel(parentDate: String) -> SoldItemModel {
        SoldItemModel(id: id, name: name, price: price, qty: qty, image: image, parentDate: parentDate)
    }
}
