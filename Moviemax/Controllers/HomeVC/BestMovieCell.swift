//
//  BestMovieCell.swift
//  Moviemax
//
//  Created by Жадаев Алексей on 05.04.2023.
//

import UIKit

class BestMovieCell: UICollectionViewCell {
    //MARK: - properties
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "image1")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .systemBackground
        label.layer.cornerRadius = 24
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    func configure(title: String, genre: String) {
        titleLabel.text = title
        genreLabel.text = genre
    }
    
    //MARK: - private setup methods
    private func setupView() {
        layer.cornerRadius = 16
        addSubview(backgroundImage)
        addSubview(genreLabel)
        addSubview(titleLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            genreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            genreLabel.heightAnchor.constraint(equalToConstant: 20),
            genreLabel.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -100),
            genreLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 6),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
    }
}
