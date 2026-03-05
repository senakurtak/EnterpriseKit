//
//  Product.swift
//  EnterpriseKit
//
//  Created by Sena Kurtak on 6.03.2026.
//

import Foundation

struct Product: Identifiable, Codable {
    let productId: String
    let title: String
    let description: String
    let price: Double
    let currency: String
    let image: String
    let categoryId: String
    let stock: Int
    let rating: Double
    
    var id: String { productId } // MockAPI internal id
}
