//
//  CustomCartCell.swift
//  EnterpriseKit
//
//  Created by Sena Kurtak on 18.03.2026.
//

import UIKit

final class CustomCartCell: UITableViewCell {
    
    static let identifier = "CustomCartCell"
    
    // MARK: - UI
    
    private let productImageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let quantityLabel = UILabel()
    
    private let minusButton = UIButton(type: .system)
    private let plusButton = UIButton(type: .system)
    
    // MARK: - Callbacks
    
    var onIncreaseTapped: (() -> Void)?
    var onDecreaseTapped: (() -> Void)?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CustomCartCell {
    
    func setupUI() {
        selectionStyle = .none
        
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 8
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.numberOfLines = 2
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = .systemFont(ofSize: 14, weight: .bold)
        priceLabel.textColor = .systemGreen
        
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.font = .systemFont(ofSize: 14)
        quantityLabel.textAlignment = .center
        
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.setTitle("-", for: .normal)
        minusButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        minusButton.addTarget(self, action: #selector(decreaseTapped), for: .touchUpInside)
        
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        plusButton.addTarget(self, action: #selector(increaseTapped), for: .touchUpInside)
        
        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(minusButton)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            productImageView.widthAnchor.constraint(equalToConstant: 70),
            productImageView.heightAnchor.constraint(equalToConstant: 70),
            
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: productImageView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            
            minusButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            minusButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            minusButton.widthAnchor.constraint(equalToConstant: 30),
            
            quantityLabel.leadingAnchor.constraint(equalTo: minusButton.trailingAnchor, constant: 8),
            quantityLabel.centerYAnchor.constraint(equalTo: minusButton.centerYAnchor),
            quantityLabel.widthAnchor.constraint(equalToConstant: 40),
            
            plusButton.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 8),
            plusButton.centerYAnchor.constraint(equalTo: minusButton.centerYAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: minusButton.bottomAnchor, constant: 12)
        ])
    }
}

extension CustomCartCell {
    
    func configure(with item: CartItem) {
        titleLabel.text = "Product \(item.productId)"
        priceLabel.text = "\(item.quantity * 1000) TRY"
        quantityLabel.text = "\(item.quantity)"
        
        // todo: change mock image
        productImageView.image = UIImage(systemName: "cart")
    }
}

extension CustomCartCell {
    
    @objc func increaseTapped() {
        onIncreaseTapped?()
    }
    
    @objc func decreaseTapped() {
        onDecreaseTapped?()
    }
}
