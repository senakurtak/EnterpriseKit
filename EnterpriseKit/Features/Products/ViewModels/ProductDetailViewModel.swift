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
    var onAddToCartSuccess: (() -> Void)?
    var onAddToCartError: ((String) -> Void)?
    
    init(productId: String,
         service: ProductServiceProtocol = ProductService()) {
        self.productId = productId
        self.service = service
    }

    func addToCart(quantity: Int = 1) {
        Task {
            do {
                try await CartService().addProduct(productId: productId,
                                                    quantity: quantity)
                onAddToCartSuccess?()
            } catch {
                onAddToCartError?(error.localizedDescription)
            }
        }
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
