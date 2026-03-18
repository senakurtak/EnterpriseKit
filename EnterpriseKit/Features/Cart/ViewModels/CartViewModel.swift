//
//  CartViewModel.swift
//  EnterpriseKit
//
//  Created by Sena Kurtak on 6.03.2026.
//

import Foundation

@MainActor
final class CartViewModel {
    
    // MARK: - State
    
    private(set) var items: [CartItem] = []
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?
    
    var totalItemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    // MARK: - Callbacks
    
    var onCartUpdated: (() -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Dependencies
    
    private let service: CartServiceProtocol
    
    init(service: CartServiceProtocol = CartService()) {
        self.service = service
    }
    
    // MARK: - Public Methods
    
    func loadCart() {
        Task {
            await fetchCart()
        }
    }
    
    func addToCart(productId: String) {
        Task {
            isLoading = true
            onLoadingChanged?(true)
            
            defer {
                isLoading = false
                onLoadingChanged?(false)
            }
            
            do {
                if let existingItem = items.first(where: { $0.productId == productId }) {
                    try await service.updateQuantity(
                        cartId: existingItem.id,
                        quantity: existingItem.quantity + 1
                    )
                } else {
                    try await service.addProduct(
                        productId: productId,
                        quantity: 1
                    )
                }
                
                items = try await service.fetchCart()
                onCartUpdated?()
                
            } catch {
                errorMessage = error.localizedDescription
                onError?(error.localizedDescription)
            }
        }
    }
    
    func removeItem(at index: Int) {
        Task {
            guard index < items.count else { return }
            
            isLoading = true
            onLoadingChanged?(true)
            
            defer {
                isLoading = false
                onLoadingChanged?(false)
            }
            
            do {
                let item = items[index]
                try await service.removeCartItem(cartId: item.id)
                
                items = try await service.fetchCart()
                onCartUpdated?()
                
            } catch {
                errorMessage = error.localizedDescription
                onError?(error.localizedDescription)
            }
        }
    }
    
    func increaseQuantity(for item: CartItem) {
        Task {
            try? await service.updateQuantity(
                cartId: item.id,
                quantity: item.quantity + 1
            )
            await fetchCart()
        }
    }

    func decreaseQuantity(for item: CartItem) {
        guard item.quantity > 1 else { return }
        
        Task {
            try? await service.updateQuantity(
                cartId: item.id,
                quantity: item.quantity - 1
            )
            await fetchCart()
        }
    }
}

// MARK: - Private

private extension CartViewModel {
    
    func fetchCart() async {
        isLoading = true
        onLoadingChanged?(true)
        
        defer {
            isLoading = false
            onLoadingChanged?(false)
        }
        
        do {
            items = try await service.fetchCart()
            onCartUpdated?()
        } catch {
            errorMessage = error.localizedDescription
            onError?(error.localizedDescription)
        }
    }
}


