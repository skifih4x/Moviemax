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
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .systemBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 0
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImage.layer.cornerRadius = 10
        backgroundImage.clipsToBounds = true
        genreLabel.layer.cornerRadius = 5
        genreLabel.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        backgroundImage.image = nil
    }
    
    //MARK: - configuration method
    func configure(with movie: MultimediaViewModel) {
        titleLabel.text = movie.titleName
        genreLabel.text = movie.genre
        getImage(from: movie.posterImageLink)
    }
    
    //MARK: - private setup methods
    private func setupView() {
        addSubview(backgroundImage)
        addSubview(genreLabel)
        addSubview(titleLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.heightAnchor.constraint(equalToConstant: 250),
            backgroundImage.widthAnchor.constraint(equalTo: backgroundImage.heightAnchor, multiplier: 0.7),
            backgroundImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            genreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            genreLabel.heightAnchor.constraint(equalToConstant: 20),
            genreLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    private func getImage(from string: String) {
        MultimediaLoader.shared.fetchImage(from: string) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.backgroundImage.image = image
            }
        }
    }
}
