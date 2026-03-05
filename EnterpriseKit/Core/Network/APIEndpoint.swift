//
//  APIEndpoint.swift
//  EnterpriseKit
//
//  Created by Sena Kurtak on 6.03.2026.
//

import Foundation

enum APIEndpoint {
    
    static let baseURL = "https://69a9eb6632e2d46caf47a1eb.mockapi.io/api/v1"
    
    case getProducts
    case getProduct(id: String)
    case getCart
    case addToCart
    case updateCart(id: String)
    case deleteCart(id: String)
    
    var url: URL? {
        switch self {
        case .getProducts:
            return URL(string: "\(Self.baseURL)/products")
        case .getProduct(let id):
            return URL(string: "\(Self.baseURL)/products/?productId=\(id)")
        case .getCart:
            return URL(string: "\(Self.baseURL)/cart")

        case .addToCart:
            return URL(string: "\(Self.baseURL)/cart")

        case .updateCart(let id):
            return URL(string: "\(Self.baseURL)/cart/\(id)")

        case .deleteCart(let id):
            return URL(string: "\(Self.baseURL)/cart/\(id)")
        }
    }
}
