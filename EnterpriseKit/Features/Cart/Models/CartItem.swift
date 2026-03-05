//
//  CartItem.swift
//  EnterpriseKit
//
//  Created by Sena Kurtak on 6.03.2026.
//

import Foundation

struct CartItem: Identifiable, Codable {
    let id: String
    let productId: String
    var quantity: Int
}
