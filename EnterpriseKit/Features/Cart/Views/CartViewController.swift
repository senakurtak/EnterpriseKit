//
//  CartView.swift
//  EnterpriseKit
//
//  Created by Sena Kurtak on 6.03.2026.
//

import UIKit

final class CartViewController: UIViewController {
    
    // MARK: - UI
    
    private let tableView = UITableView()
    private let totalContainerView = UIView()
    private let totalLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let emptyStateLabel = UILabel()
    private var displayedCartItems: [CartItem] = [] { //todo: remove this variable on clean up
        didSet {
            tableView.reloadData()
            totalLabel.text = "Total: \(calculateTotal()) TRY"
            emptyStateLabel.isHidden = !displayedCartItems.isEmpty
        }
    }
    
    
    // MARK: - ViewModel
    
    private let viewModel = CartViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cart"
        view.backgroundColor = .systemBackground
        
        setupTableView()
        setupTotalSection()
        setupLoadingIndicator()
        setupEmptyState()
        bindViewModel()
        
        viewModel.loadCart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadCart()
    }
}

private extension CartViewController {
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomCartCell.self, forCellReuseIdentifier: CustomCartCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70)
        ])
    }
    
    func setupTotalSection() {
        totalContainerView.translatesAutoresizingMaskIntoConstraints = false
        totalContainerView.backgroundColor = .secondarySystemBackground
        
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.font = .systemFont(ofSize: 18, weight: .bold)
        totalLabel.textAlignment = .center
        
        totalContainerView.addSubview(totalLabel)
        view.addSubview(totalContainerView)
        
        NSLayoutConstraint.activate([
            totalContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            totalContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            totalContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            totalContainerView.heightAnchor.constraint(equalToConstant: 70),
            
            totalLabel.centerXAnchor.constraint(equalTo: totalContainerView.centerXAnchor),
            totalLabel.centerYAnchor.constraint(equalTo: totalContainerView.centerYAnchor)
        ])
    }
    
    func setupLoadingIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupEmptyState() {
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.text = "Your cart is empty"
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.textColor = .secondaryLabel
        emptyStateLabel.isHidden = true
        
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

private extension CartViewController {
    
    func bindViewModel() {
        
        viewModel.onCartUpdated = { [weak self] in
            guard let self else { return }
            self.displayedCartItems = self.viewModel.items
        }
        
        viewModel.onLoadingChanged = { [weak self] isLoading in
            isLoading
            ? self?.activityIndicator.startAnimating()
            : self?.activityIndicator.stopAnimating()
        }
        
        viewModel.onError = { [weak self] message in
            //guard let message else { return }
            let alert = UIAlertController(title: "Error",
                                          message: message,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
        
        viewModel.onCartUpdated = { [weak self] in
            guard let self else { return }
            
            self.tableView.reloadData()
            self.totalLabel.text = "Total: \(self.calculateTotal()) TRY"
            self.emptyStateLabel.isHidden = !self.viewModel.items.isEmpty
            
            self.updateTabBarBadge()
        }
    }
}

private extension CartViewController {
    
    func calculateTotal() -> Double {
        viewModel.items.reduce(0) { result, item in
            result + (item.price * Double(item.quantity))
        }
    }
    
    private func updateTabBarBadge() {
        guard let tabBarController = tabBarController else { return }
        
        let count = viewModel.totalItemCount
        
        let cartTabIndex = 1 // Todo: change tabbar index when expand tabbar
        
        if let items = tabBarController.tabBar.items,
           items.indices.contains(cartTabIndex) {
            
            items[cartTabIndex].badgeValue =
                count > 0 ? "\(count)" : nil
        }
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        
        let item = viewModel.items[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CustomCartCell.identifier,
            for: indexPath
        ) as! CustomCartCell
        
        cell.configure(with: item)
        
        cell.onIncreaseTapped = { [weak self] in
            self?.viewModel.increaseQuantity(for: item)
        }
        
        cell.onDecreaseTapped = { [weak self] in
            self?.viewModel.decreaseQuantity(for: item)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            viewModel.removeItem(at: indexPath.row)
        }
    }
}
