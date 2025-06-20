//
//  misscealaneousmodel.swift
//  InventoryApp
//
//  Created by Sanskar IOS Dev on 05/08/24.
//

import Foundation


struct MiscellaneousItem: Decodable {
    let id: String
    let misc_item_name: String
}

struct MiscellaneousItemResponse: Decodable {
    let status: Bool
    let message: String
    let data: [MiscellaneousItem]
    let error: String?
}
struct InventoryItem {
    let name: String
    let quantity: String
}

struct MiscProduct: Codable {
    var itemName: String
    var itemQuantity: String
}
