//
//  UserHeaderView.swift
//  Moviemax
//
//  Created by Жадаев Алексей on 05.04.2023.
//

import UIKit

final class UserHeaderView: UICollectionReusableView {
    //MARK: - properties
    static let headerIdentifier = "UserHeaderView"
    
    lazy var avatarView: UIImageView = {
        let avatarView = UIImageView()
        avatarView.image = UIImage(systemName: "person")
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        return avatarView
    }()
    
    lazy var usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        usernameLabel.text = "Hi, Andy"
        usernameLabel.textAlignment = .left
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        return usernameLabel
    }()
    
    lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
        descriptionLabel.text = "only streaming movie lovers"
        descriptionLabel.textColor = .systemGray
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
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
    
    //MARK: - private setup methods
    private func setupView() {
        backgroundColor = .systemBackground
        addSubview(avatarView)
        addSubview(usernameLabel)
        addSubview(descriptionLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            avatarView.topAnchor.constraint(equalTo: topAnchor),
            avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor),
            avatarView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            usernameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor),
            usernameLabel.topAnchor.constraint(equalTo: avatarView.topAnchor),
            usernameLabel.heightAnchor.constraint(equalTo: avatarView.heightAnchor, multiplier: 0.5),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
