//
//  CategoryCell.swift
//  Moviemax
//
//  Created by Жадаев Алексей on 05.04.2023.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    //MARK: - properties
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6431372549, blue: 0.6705882353, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? #colorLiteral(red: 0.3176470588, green: 0.3058823529, blue: 0.7137254902, alpha: 1) : .systemBackground
            categoryLabel.textColor = isSelected ? .systemBackground : #colorLiteral(red: 0.6117647059, green: 0.6431372549, blue: 0.6705882353, alpha: 1)
        }
    }
    
    //MARK: - initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //MARK: - configuration method
    func configure(with category: MovieGenre?) {
        if let category = category {
            categoryLabel.text = category.name
        } else {
            categoryLabel.text = "All"
        }
    }
    
    //MARK: - private setup methods
    private func setupView() {
        layer.cornerRadius = 18.0
        layer.borderColor = #colorLiteral(red: 0.8901960784, green: 0.9137254902, blue: 0.9294117647, alpha: 1)
        layer.borderWidth = 1.0
        addSubview(categoryLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.0),
            categoryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 7.0),
            categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.0),
            categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7.0)
        ])
    }
}
