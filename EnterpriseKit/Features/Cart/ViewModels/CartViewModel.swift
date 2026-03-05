//
//  CartViewModel.swift
//  EnterpriseKit
//
//  Created by Sena Kurtak on 6.03.2026.
//

import Foundation

@MainActor
final class CartViewModel: ObservableObject {
    
    // MARK: - Published State
    
    @Published private(set) var items: [CartItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
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
            do {
                if let existingItem = items.first(where: { $0.productId == productId }) {
                    // Ürün zaten varsa quantity artır
                    try await service.updateQuantity(
                        cartId: existingItem.id,
                        quantity: existingItem.quantity + 1
                    )
                } else {
                    // Yoksa yeni ekle
                    try await service.addProduct(
                        productId: productId,
                        quantity: 1
                    )
                }
                
                await fetchCart()
                
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func removeItem(_ item: CartItem) {
        Task {
            do {
                try await service.removeCartItem(cartId: item.id)
                await fetchCart()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

private extension CartViewModel {
    
    func fetchCart() async {
        isLoading = true
        errorMessage = nil
        
        do {
            items = try await service.fetchCart()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
