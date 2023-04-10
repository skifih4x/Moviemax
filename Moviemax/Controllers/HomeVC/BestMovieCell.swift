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
        label.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .systemBackground
        label.layer.cornerRadius = 24
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
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
        backgroundImage.layer.cornerRadius = 20
        layer.cornerRadius = contentView.frame.height / 2
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
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            genreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            genreLabel.heightAnchor.constraint(equalToConstant: 20),
            genreLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 6),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
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
