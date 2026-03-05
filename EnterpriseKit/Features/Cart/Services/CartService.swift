//
//  CartService.swift
//  EnterpriseKit
//
//  Created by Sena Kurtak on 6.03.2026.
//

import Foundation

protocol CartServiceProtocol {
    func fetchCart() async throws -> [CartItem]
    func addProduct(productId: String, quantity: Int) async throws
    func updateQuantity(cartId: String, quantity: Int) async throws
    func removeCartItem(cartId: String) async throws
}

final class CartService: CartServiceProtocol {
    
    func fetchCart() async throws -> [CartItem] {
        try await NetworkService.shared.request(.getCart)
    }
    
    func addProduct(productId: String, quantity: Int) async throws {
        
        let requestBody = AddToCartRequest(
            productId: productId,
            quantity: quantity
        )
        
        let body = try JSONEncoder().encode(requestBody)
        
        let _: CartItem = try await NetworkService.shared.request(
            .addToCart,
            method: "POST",
            body: body
        )
    }
    
    func updateQuantity(cartId: String, quantity: Int) async throws {
        let body = try JSONEncoder().encode(
            ["quantity": quantity]
        )
        
        let _: CartItem = try await NetworkService.shared.request(
            .updateCart(id: cartId),
            method: "PUT",
            body: body
        )
    }
    
    func removeCartItem(cartId: String) async throws {
        let _: CartItem = try await NetworkService.shared.request(
            .deleteCart(id: cartId),
            method: "DELETE"
        )
    }
}
