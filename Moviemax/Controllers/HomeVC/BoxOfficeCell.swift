//
//  BoxOfficeCell.swift
//  Moviemax
//
//  Created by Жадаев Алексей on 05.04.2023.
//

import UIKit

class BoxOfficeCell: UICollectionViewCell {
    //MARK: - properties
    private let movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6431372549, blue: 0.6705882353, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.7490196078, green: 0.7764705882, blue: 0.8, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    //time stack
    private let timeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "clock")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let timeAmount: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = #colorLiteral(red: 0.4705882353, green: 0.5098039216, blue: 0.5411764706, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let timeUnits: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = #colorLiteral(red: 0.4705882353, green: 0.5098039216, blue: 0.5411764706, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //rating stack
    private let ratingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = #colorLiteral(red: 0.9803921569, green: 0.8, blue: 0.08235294118, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let ratingScore: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = #colorLiteral(red: 0.9803921569, green: 0.8, blue: 0.08235294118, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let ratingCount: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6431372549, blue: 0.6705882353, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //stacks
    private lazy var timeStack: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [timeImage, timeAmount, timeUnits])
        hStack.spacing = 5
        hStack.translatesAutoresizingMaskIntoConstraints = false
        return hStack
    }()
    
    private lazy var ratingStack: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [ratingImage, ratingScore, ratingCount])
        hStack.spacing = 5
        hStack.translatesAutoresizingMaskIntoConstraints = false
        return hStack
    }()
    
    private lazy var mainStack: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [genreLabel, titleLabel, timeStack])
        vStack.axis = .vertical
        vStack.distribution = .fill
        vStack.alignment = .leading
        vStack.spacing = 0
        vStack.setCustomSpacing(5, after: titleLabel)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
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
        backgroundColor = .clear
        addSubview(movieImage)
        addSubview(mainStack)
        addSubview(ratingStack)
        addSubview(likeButton)
        setupConstraints()
        
        movieImage.image = UIImage(named: "image1")
        timeAmount.text = "148"
        timeUnits.text = "Minutes"
        ratingScore.text = "4.4"
        ratingCount.text = "(52)"
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            movieImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieImage.topAnchor.constraint(equalTo: topAnchor),
            movieImage.widthAnchor.constraint(equalTo: movieImage.heightAnchor),
            movieImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            mainStack.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 12),
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            mainStack.trailingAnchor.constraint(equalTo: ratingStack.leadingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            likeButton.heightAnchor.constraint(equalToConstant: 17),
            likeButton.widthAnchor.constraint(equalToConstant: 19),
            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            ratingStack.heightAnchor.constraint(equalToConstant: 20),
            ratingStack.widthAnchor.constraint(equalToConstant: 70),
            ratingStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            ratingStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}
