//
//   ProductDetailViewController.swift
//  EnterpriseKit
//
//  Created by Sena Kurtak on 6.03.2026.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    
    // MARK: - UI
    
    let scrollView = UIScrollView()
    let contentStack = UIStackView()
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    let ratingLabel = UILabel()
    let stockLabel = UILabel()
    let descriptionLabel = UILabel()
    let addToCartButton = UIButton(type: .system)
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - ViewModel
    
    private let viewModel: ProductDetailViewModel
    
    // MARK: - Init
    
    init(productId: String) {
        self.viewModel = ProductDetailViewModel(productId: productId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Product Detail"
        
        setupUI()
        bindViewModel()
        
        activityIndicator.startAnimating()
        viewModel.loadProduct()
    }
}

private extension ProductDetailViewController {
    
    func setupUI() {
        setupScrollView()
        setupImageView()
        setupLabels()
        setupButton()
        setupLoading()
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentStack.axis = .vertical
        contentStack.spacing = 16
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32)
        ])
    }
    
    func setupImageView() {
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        imageView.contentMode = .scaleAspectFit
        contentStack.addArrangedSubview(imageView)
    }
    
    func setupLabels() {
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        priceLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        priceLabel.textColor = .systemBlue
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .secondaryLabel
        
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(priceLabel)
        contentStack.addArrangedSubview(ratingLabel)
        contentStack.addArrangedSubview(stockLabel)
        contentStack.addArrangedSubview(descriptionLabel)
    }
    
    func setupButton() {
        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.backgroundColor = .systemBlue
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.layer.cornerRadius = 10
        addToCartButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        contentStack.addArrangedSubview(addToCartButton)
    }
    
    func setupLoading() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

private extension ProductDetailViewController {
    
    func bindViewModel() {
        viewModel.onProductLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.configureUI()
            }
        }
        
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.showError(message)
            }
        }
    }
    
    func configureUI() {
        guard let product = viewModel.product else { return }
        
        titleLabel.text = product.title
        priceLabel.text = "\(product.price) \(product.currency)"
        ratingLabel.text = "⭐️ \(product.rating)"
        stockLabel.text = product.stock > 0 ? "In Stock (\(product.stock))" : "Out of Stock"
        stockLabel.textColor = product.stock > 0 ? .systemGreen : .systemRed
        descriptionLabel.text = product.description
        
        loadImage(from: product.image)
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

private extension ProductDetailViewController {
    
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            } catch {
                print("Image loading failed")
            }
        }
    }
}
