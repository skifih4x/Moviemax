//
//  BoxOfficeCell.swift
//  Moviemax
//
//  Created by Жадаев Алексей on 05.04.2023.
//

import UIKit

final class BoxOfficeCell: UICollectionViewCell {
    //MARK: - properties
    private var databaseService: DatabaseService = RealmService.shared
    private var currentMovie: MultimediaViewModel?
    private let filmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Drifting Home"
        label.textColor = UIColor(named: K.Colors.titleColor)
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.7490196078, green: 0.7764705882, blue: 0.8, alpha: 1)
        return button
    }()
    private let timeLabel = UILabel(text: "148 Minutes", font: UIFont.systemFont(ofSize: 15),  textColor: UIColor(named: K.Colors.labelColor))
    private let imageTime = UIImageView(image: UIImage(named: "star-4"), contentMode: .scaleAspectFill)
    private let dataLabel = UILabel(text: "17 Sep 2021", font: UIFont.systemFont(ofSize: 15), textColor: UIColor(named: K.Colors.labelColor))
    private let imageData = UIImageView(image: UIImage(named: "calendar"), contentMode: .scaleAspectFill)
    private let imageGenre = UIImageView(image: UIImage(named: "genre"), contentMode: .scaleAspectFill)
    private let genreView = GenreView(frame: .zero)
    var isButtonTapped = false
    
    //MARK: - initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func prepareForReuse() {
        filmImageView.image = nil
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        isButtonTapped = false
    }
    
    //MARK: button
    @objc func buttonPressed(_ sender: UIButton) {
        changeImageButton()
        
        //work with Realm
        guard let movieModel = currentMovie else { return }
        isButtonTapped
        ? databaseService.addToFavorites(movieModel)
        : databaseService.deleteMovie(movieModel.id)
    }
    
    func changeImageButton() {
        let image = isButtonTapped ? UIImage(systemName: "heart") : UIImage(systemName: "heart.fill")
        likeButton.setImage(image, for: .normal)
        isButtonTapped.toggle()
    }
    
    //MARK: - layout
    override func layoutSubviews() {
        super.layoutSubviews()
        filmImageView.layer.cornerRadius = 10
        filmImageView.clipsToBounds = true
    }
    
    //MARK: - configuration methods
    func configure(with movie: MultimediaViewModel) {
        self.nameLabel.text = movie.titleName
        setImage(nameImage: movie.posterImageLink)
        self.timeLabel.text = "\(movie.rating)"
        self.dataLabel.text = "\(movie.releaseDate)"
        self.genreView.genreLabel.text = movie.genre
        self.currentMovie = movie
    }
    
    //MARK: private support methods
    private func setImage(nameImage: String) {
        MultimediaLoader.shared.fetchImage(from: nameImage) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.filmImageView.image = image
            }
        }
    }
    
    //MARK: - private setup methods
    private func setupView() {
        backgroundColor = .clear
        setupConstraints()
        bringSubviewToFront(likeButton)
        likeButton.addTarget(nil, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        filmImageView.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        imageTime.translatesAutoresizingMaskIntoConstraints = false
        imageData.translatesAutoresizingMaskIntoConstraints = false
        imageGenre.translatesAutoresizingMaskIntoConstraints = false
        genreView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            likeButton.heightAnchor.constraint(equalToConstant: 23),
            likeButton.widthAnchor.constraint(equalToConstant: 26),
            
            imageTime.heightAnchor.constraint(equalToConstant: 14),
            imageTime.widthAnchor.constraint(equalToConstant: 14),
            
            imageData.heightAnchor.constraint(equalToConstant: 14),
            imageData.widthAnchor.constraint(equalToConstant: 14),
            
            imageGenre.heightAnchor.constraint(equalToConstant: 14),
            imageGenre.widthAnchor.constraint(equalToConstant: 14),
        ])
        
        let topStack = UIStackView(arrangedSubviews: [nameLabel], axis: .horizontal, spacing: 10)
        topStack.distribution = .fill
        let timeStack = UIStackView(arrangedSubviews: [imageTime, timeLabel], axis: .horizontal, spacing: 5)
        let dataStack = UIStackView(arrangedSubviews: [imageData, dataLabel], axis: .horizontal, spacing: 5)
        let genreStack = UIStackView(arrangedSubviews: [imageGenre, genreView], axis: .horizontal, spacing: 5)
        let mainStack = UIStackView(arrangedSubviews: [topStack, timeStack, dataStack, genreStack], axis: .vertical, spacing: 5)
        mainStack.distribution = .fill
        mainStack.alignment = .leading
        
        addSubview(filmImageView)
        addSubview(likeButton)
        addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            filmImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            filmImageView.widthAnchor.constraint(equalTo: filmImageView.heightAnchor, multiplier: 0.8),
            filmImageView.topAnchor.constraint(equalTo: topAnchor),
            filmImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            mainStack.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 12),
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: -24),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5),
            
            likeButton.topAnchor.constraint(equalTo: topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
