//
//  ProductListViewModel.swift
//  EnterpriseKit
//
//  Created by Sena Kurtak on 6.03.2026.
//

import Foundation

final class ProductDetailViewModel {
    
    private let productId: String // todo: revoke it
   // private let cartItem: CartItem
    private let service: ProductServiceProtocol
    
    var product: Product?
    
    var onProductLoaded: (() -> Void)?
    var onError: ((String) -> Void)?
    var onAddToCartSuccess: (() -> Void)?
    var onAddToCartError: ((String) -> Void)?
    // imageUrl', 'price', 'name'
    init(productId: String,
         service: ProductServiceProtocol = ProductService()) {
        self.productId = productId
        self.service = service
    }
    
    func addToCart(quantity: Int = 1) {
        guard let product else { return }
        
        Task {
            do {
                
                let request = AddToCartRequest(
                    productId: product.id,
                    quantity: quantity,
                    image: product.image,
                    price: product.price,
                    name: product.title,
                    currency: product.currency
                )
                
                _ = try await CartService().addProduct(request: request)
                
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
