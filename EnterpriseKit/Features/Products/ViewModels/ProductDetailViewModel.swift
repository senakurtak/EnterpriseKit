//
//  ProductListViewModel.swift
//  EnterpriseKit
//
//  Created by Sena Kurtak on 6.03.2026.
//

import Foundation

final class ProductDetailViewModel {
    
    private let productId: String
    private let service: ProductServiceProtocol
    
    var product: Product?
    
    var onProductLoaded: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init(productId: String,
         service: ProductServiceProtocol = ProductService()) {
        self.productId = productId
        self.service = service
    }
    
    func loadProduct() {
        Task {
            do {
                product = try await service.fetchProduct(id: productId)
                onProductLoaded?()
            } catch {
                onError?(error.localizedDescription)
            }
        }
    }
}
