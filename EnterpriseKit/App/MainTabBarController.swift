//
//  MainTabBarController.swift
//  EnterpriseKit
//
//  Created by Sena Kurtak on 17.03.2026.
//

import UIKit

extension Notification.Name { // todo: change place
    static let cartUpdated = Notification.Name("cartUpdated")
}

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        updateBadge()
        observeCartChanges()
    }
    
    private func setupTabs() {
        // Home
        let homeVC = ProductListViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        let cartVC = CartViewController()
        let cartNav = UINavigationController(rootViewController: cartVC)
        cartNav.tabBarItem = UITabBarItem(
            title: "Cart",
            image: UIImage(systemName: "cart"),
            selectedImage: UIImage(systemName: "cart.fill")
        )
        
        viewControllers = [homeNav, cartNav]
    }
    
    private func observeCartChanges() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateBadge),
            name: .cartUpdated,
            object: nil
        )
    }
    
    @objc private func updateBadge() {
        Task {
            let count = await fetchCartCount()
            
            DispatchQueue.main.async {
                let cartIndex = 1
                if let items = self.tabBar.items,
                   items.indices.contains(cartIndex) {
                    items[cartIndex].badgeValue =
                        count > 0 ? "\(count)" : nil
                }
            }
        }
    }
    
    private func fetchCartCount() async -> Int {
        do {
            let items = try await CartService().fetchCart()
            return items.reduce(0) { $0 + $1.quantity }
        } catch {
            return 0
        }
    }
}
