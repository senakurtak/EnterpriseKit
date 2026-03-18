//
//  CartItem.swift
//  EnterpriseKit
//
//  Created by Sena Kurtak on 6.03.2026.
//

import Foundation

struct CartItem: Identifiable, Codable, Hashable {
    let id: String
    let productId: String
    var quantity: Int
    let imageUrl: String
    let price: Double
    let name: String
    let currency: String
}
