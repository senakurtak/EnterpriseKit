//
//  AddToCartRequest.swift
//  EnterpriseKit
//
//  Created by Sena Kurtak on 6.03.2026.
//

import Foundation

struct AddToCartRequest: Codable {
    let productId: String
    let quantity: Int
}
