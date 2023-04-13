//
//  CellFilmTableView.swift
//  Moviemax
//
//  Created by Андрей Фроленков on 4.04.23.
//

import Foundation
import UIKit

class CellFilmTableView: UITableViewCell {
    
    let filmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Drifting Home"
        label.textColor = UIColor(named: K.Colors.titleColor)
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    // Time Stack
    let timeLabel = UILabel(text: "148 Minutes", font: UIFont.systemFont(ofSize: 15),  textColor: UIColor(named: K.Colors.labelColor))
    let imageTime = UIImageView(image: UIImage(named: "star-4"), contentMode: .scaleAspectFill)
    // Data Stack
    let dataLabel = UILabel(text: "17 Sep 2021", font: UIFont.systemFont(ofSize: 15), textColor: UIColor(named: K.Colors.labelColor))
    let imageData = UIImageView(image: UIImage(named: "calendar"), contentMode: .scaleAspectFill)
    
    // Genre Stack
    let imageGenre = UIImageView(image: UIImage(named: "genre"), contentMode: .scaleAspectFill)
    
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.7490196078, green: 0.7764705882, blue: 0.8, alpha: 1)
        return button
    }()
    
    let genreView = GenreView(frame: .zero)
    
    var buttonTapped = false
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        likeButton.addTarget(nil, action: #selector(VideoViewController.buttonPressed), for: .touchUpInside)
        setupConstraints()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        filmImageView.layer.cornerRadius = contentView.frame.height / 7
        
    }
    
    func cellConfigure(with model: MultimediaViewModel) {
        
        self.nameLabel.text = model.titleName
        setImage(nameImage: model.posterImageLink)
        self.timeLabel.text = "\(model.id) Minutes"
        self.dataLabel.text = "\(model.releaseDate)"
        self.genreView.genreLabel.text = model.genre
    }
    
    func cellConfigureMovie(with model: Movie, genre: MovieGenre) {
    
        self.nameLabel.text = model.name ?? model.title
        setImage(nameImage: model.posterPath ?? "")
        self.timeLabel.text = "\(model.voteAverage)"
        self.dataLabel.text = "\(model.releaseDate ?? model.firstAirDate ?? "")"
        self.genreView.genreLabel.text = genre.name
    }
    
    func setImage(nameImage: String) {
        
        MultimediaLoader.shared.fetchImage(from: nameImage) { [weak self] image in
            
            DispatchQueue.main.async {
                self?.filmImageView.image = image
            }
        }
    }
      
    func changeImageButton() {
        let image = buttonTapped ? UIImage(systemName: "heart") : UIImage(systemName: "heart.fill")
        likeButton.setImage(image, for: .normal)
        buttonTapped = !buttonTapped
    }
    
    func setupConstraints() {
        filmImageView.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        imageTime.translatesAutoresizingMaskIntoConstraints = false
        imageData.translatesAutoresizingMaskIntoConstraints = false
        imageGenre.translatesAutoresizingMaskIntoConstraints = false
        
        // Like button
        NSLayoutConstraint.activate([
            likeButton.heightAnchor.constraint(equalToConstant: 23),
            likeButton.widthAnchor.constraint(equalToConstant: 26),
        ])
        // Time image
        NSLayoutConstraint.activate([
            imageTime.heightAnchor.constraint(equalToConstant: 14),
            imageTime.widthAnchor.constraint(equalToConstant: 14),
        ])
        // Data image
        NSLayoutConstraint.activate([
            imageData.heightAnchor.constraint(equalToConstant: 14),
            imageData.widthAnchor.constraint(equalToConstant: 14),
        ])
        // Genre image
        NSLayoutConstraint.activate([
            imageGenre.heightAnchor.constraint(equalToConstant: 14),
            imageGenre.widthAnchor.constraint(equalToConstant: 14),
        ])
        
        let topStack = UIStackView(arrangedSubviews: [nameLabel, likeButton], axis: .horizontal, spacing: 10)
        topStack.alignment = .center
        let timeStack = UIStackView(arrangedSubviews: [imageTime, timeLabel], axis: .horizontal, spacing: 5)
        let dataStack = UIStackView(arrangedSubviews: [imageData, dataLabel], axis: .horizontal, spacing: 5)
        let genreStack = UIStackView(arrangedSubviews: [imageGenre, genreView], axis: .horizontal, spacing: 5)
        
        contentView.addSubview(filmImageView)
        contentView.addSubview(topStack)
        contentView.addSubview(timeStack)
        contentView.addSubview(dataStack)
        contentView.addSubview(genreStack)
        
        
        topStack.translatesAutoresizingMaskIntoConstraints = false
        timeStack.translatesAutoresizingMaskIntoConstraints = false
        dataStack.translatesAutoresizingMaskIntoConstraints = false
        genreStack.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
                        filmImageView.heightAnchor.constraint(equalToConstant: 160),
            filmImageView.widthAnchor.constraint(equalToConstant: 120),
            filmImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
//            filmImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            filmImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        // Top Stack
        NSLayoutConstraint.activate([
            topStack.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 12),
            topStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            topStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
        ])
        // Time Stack
        NSLayoutConstraint.activate([
            timeStack.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 12),
            timeStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            timeStack.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 12),
        ])
        
        // Data Stack
        NSLayoutConstraint.activate([
            dataStack.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 12),
            dataStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            dataStack.topAnchor.constraint(equalTo: timeStack.bottomAnchor, constant: 14),
        ])
        
        // Genre Stack
        NSLayoutConstraint.activate([
            
            genreStack.topAnchor.constraint(equalTo: dataStack.bottomAnchor, constant: 10),
            genreStack.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 12),
//            genreView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
