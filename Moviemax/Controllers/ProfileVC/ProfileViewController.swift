//
//  ProfileViewController.swift
//  Moviemax
//
//  Created by Андрей Фроленков on 3.04.23.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: - let/var
    
    var navigationBar = UINavigationBar()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "arrow.backward")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 24
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(ProfileViewController.self, action: #selector(backButtonTaped), for: .touchUpInside)
        
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileImage")
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var profileStackView = UIStackView()
    
    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Andy Lexsian"
        label.font = label.font.withSize(18)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@Andy1999"
        label.font = label.font.withSize(14)
        label.textColor = .systemGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    //MARK: - life cycle funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
        setConstraints()
    }
    
    //MARK: - flow funcs
    
    @objc private func backButtonTaped() {
        let controller = HomeViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - public
    
}

//MARK: - extensions setupViews

extension ProfileViewController {
    
    private func setupViews() {
        view.addSubview(navigationBar)
        view.addSubview(backButton)
        
        view.addSubview(profileImageView)
        
        profileStackView = UIStackView(
            arrangedSubviews: [profileNameLabel, nickNameLabel],
            axis: .vertical,
            spacing: 2
        )
        view.addSubview(profileStackView)
        
        
    }
}

//MARK: - extensions setConstraints

extension ProfileViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 24),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            backButton.widthAnchor.constraint(equalToConstant: 48),
            backButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            profileImageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 24),
            profileImageView.widthAnchor.constraint(equalToConstant: 56),
            profileImageView.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        NSLayoutConstraint.activate([
            profileNameLabel.heightAnchor.constraint(equalToConstant: 26)
        ])
        
        NSLayoutConstraint.activate([
            nickNameLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            profileStackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 24),
            profileStackView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 24)
        ])
    }
}
