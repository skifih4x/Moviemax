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
    
    private let personalInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Personal Info"
        label.font = label.font.withSize(12)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let personImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Person")
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let personLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.font = label.font.withSize(16)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "IconNext")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let securityInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Security"
        label.font = label.font.withSize(12)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var changePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "Lock")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(changePasswordButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let changePasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Change Password"
        label.font = label.font.withSize(16)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "Unlock")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let forgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot Password"
        label.font = label.font.withSize(16)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var darkModeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "Activity")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(darkModeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let darkModeLabel: UILabel = {
        let label = UILabel()
        label.text = "Dark Mode"
        label.font = label.font.withSize(16)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var customSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.isOn = false
        uiSwitch.onTintColor = #colorLiteral(red: 0.3176470588, green: 0.3058823529, blue: 0.7137254902, alpha: 1)
        uiSwitch.addTarget(self, action: #selector(switchStateDidChange), for: .valueChanged)
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        return uiSwitch
    }()
    
    private lazy var logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .none
        button.tintColor = #colorLiteral(red: 0.3176470588, green: 0.3058823529, blue: 0.7137254902, alpha: 1)
        button.layer.cornerRadius = 32
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.3176470588, green: 0.3058823529, blue: 0.7137254902, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logOutButtonTaped), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - life cycle funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
        setConstraints()
    }
    
    //MARK: - flow funcs
    
    @objc private func nextButtonTapped() {
        let newViewController = ProfileSettingsVC()
            navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @objc private func changePasswordButtonTapped() {
    }
    
    @objc private func forgotPasswordButtonTapped() {
    }
    
    @objc private func darkModeButtonTapped() {
    }
    
    @objc private func logOutButtonTaped() {
    }
    
    @objc func switchStateDidChange(_ sender: UISwitch)
    {
        if (sender.isOn == true){
            print("UISwitch state is now ON")
        }
        else{
            print("UISwitch state is now Off")
        }
    }
    
    //MARK: - public
    
}

//MARK: - extensions setupViews

extension ProfileViewController {
    
    private func setupViews() {
        view.addSubview(navigationBar)
        
        view.addSubview(profileImageView)
        
        profileStackView = UIStackView(
            arrangedSubviews: [profileNameLabel, nickNameLabel],
            axis: .vertical,
            spacing: 2
        )
        view.addSubview(profileStackView)
        
        view.addSubview(personalInfoLabel)
        view.addSubview(personImageView)
        view.addSubview(personLabel)
        
        view.addSubview(nextButton)
        
        view.addSubview(securityInfoLabel)
        
        view.addSubview(changePasswordButton)
        view.addSubview(changePasswordLabel)
        
        view.addSubview(forgotPasswordButton)
        view.addSubview(forgotPasswordLabel)
        
        view.addSubview(darkModeButton)
        view.addSubview(darkModeLabel)
        view.addSubview(customSwitch)
        
        view.addSubview(logOutButton)
    }
}

//MARK: - extensions setConstraints

extension ProfileViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 124),
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
            profileStackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            profileStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 124)
        ])
        
        NSLayoutConstraint.activate([
            personalInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            personalInfoLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 32),
            personalInfoLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            personImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            personImageView.topAnchor.constraint(equalTo: personalInfoLabel.bottomAnchor, constant: 16),
            personImageView.widthAnchor.constraint(equalToConstant: 24),
            personImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            personLabel.leadingAnchor.constraint(equalTo: personImageView.trailingAnchor, constant: 12),
            personLabel.topAnchor.constraint(equalTo: personalInfoLabel.bottomAnchor, constant: 16),
            personLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.centerYAnchor.constraint(equalTo: personLabel.centerYAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            nextButton.widthAnchor.constraint(equalToConstant: 24),
            nextButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            securityInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            securityInfoLabel.topAnchor.constraint(equalTo: personImageView.bottomAnchor, constant: 24),
            securityInfoLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            changePasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            changePasswordButton.topAnchor.constraint(equalTo: securityInfoLabel.bottomAnchor, constant: 16),
            changePasswordButton.widthAnchor.constraint(equalToConstant: 24),
            changePasswordButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            changePasswordLabel.leadingAnchor.constraint(equalTo: changePasswordButton.trailingAnchor, constant: 12),
            changePasswordLabel.centerYAnchor.constraint(equalTo: changePasswordButton.centerYAnchor),
            changePasswordLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            forgotPasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            forgotPasswordButton.topAnchor.constraint(equalTo: changePasswordButton.bottomAnchor, constant: 32),
            forgotPasswordButton.widthAnchor.constraint(equalToConstant: 24),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            forgotPasswordLabel.leadingAnchor.constraint(equalTo: forgotPasswordButton.trailingAnchor, constant: 12),
            forgotPasswordLabel.centerYAnchor.constraint(equalTo: forgotPasswordButton.centerYAnchor),
            forgotPasswordLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            darkModeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            darkModeButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 28),
            darkModeButton.widthAnchor.constraint(equalToConstant: 24),
            darkModeButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            darkModeLabel.leadingAnchor.constraint(equalTo: darkModeButton.trailingAnchor, constant: 12),
            darkModeLabel.centerYAnchor.constraint(equalTo: darkModeButton.centerYAnchor),
            darkModeLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            customSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            customSwitch.centerYAnchor.constraint(equalTo: darkModeButton.centerYAnchor),
            customSwitch.widthAnchor.constraint(equalToConstant: 44),
            customSwitch.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logOutButton.topAnchor.constraint(equalTo: darkModeLabel.bottomAnchor, constant: 200),
            logOutButton.widthAnchor.constraint(equalToConstant: 327),
            logOutButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
