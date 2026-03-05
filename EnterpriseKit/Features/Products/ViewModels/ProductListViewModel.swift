//
//  ProductListViewModel.swift
//  EnterpriseKit
//
//  Created by Sena Kurtak on 6.03.2026.
//

import Foundation

final class ProductListViewModel {
    
    private let service: ProductServiceProtocol
    
    var products: [Product] = []
    
    var onProductsUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init(service: ProductServiceProtocol = ProductService()) {
        self.service = service
    }
    
    func loadProducts() {
        Task {
            do {
                products = try await service.fetchProducts()
                onProductsUpdated?()
            } catch {
                onError?(error.localizedDescription)
            }
        }
    }
}
