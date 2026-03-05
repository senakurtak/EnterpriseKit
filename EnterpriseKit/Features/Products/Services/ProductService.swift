//
//  ProductService.swift
//  EnterpriseKit
//
//  Created by Sena Kurtak on 6.03.2026.
//

import Foundation

protocol ProductServiceProtocol {
    func fetchProducts() async throws -> [Product]
    func fetchProduct(id: String) async throws -> Product
}

final class ProductService: ProductServiceProtocol {

    func fetchProduct(id: String) async throws -> Product {
        let products: [Product] = try await NetworkService.shared.request(
            .getProduct(id: id),
            method: "GET"
        )
        
        guard let product = products.first else {
            throw NSError(domain: "Product not found", code: 404)
        }
        
        return product
    }
    func fetchProducts() async throws -> [Product] {
        try await NetworkService.shared.request(.getProducts)
    }
}
