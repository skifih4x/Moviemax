//
//  ProfileViewController.swift
//  Moviemax
//
//  Created by Андрей Фроленков on 3.04.23.
//

import UIKit

class ProfileViewController: UIViewController {
    private var databaseService = RealmService.userAuth
    
    let authManager = AuthManager()
    let alertManager = AlertControllerManager()
    let validator = ValidatorClass()
    var user: UserAuthData?
    
    private var navigationBar = UINavigationBar()
    
    //    init(with user: UserAuthData?) {
    //        self.user = user
    //        super.init(nibName: nil, bundle: nil)
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        super.init(coder: coder)
    //    }
    
    
    
    
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileImage")
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private var profileStackView = UIStackView()
    
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
    
    
    private lazy var ProfileButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "Person")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.setTitle("   Profile", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.contentHorizontalAlignment = .left
        button.tintColor = .black
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        button.setTitle("   Change Password", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.contentHorizontalAlignment = .left
        button.tintColor = .black
        button.addTarget(self, action: #selector(changePasswordButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "Lock")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.setTitle("   Forgot Password", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.contentHorizontalAlignment = .left
        button.tintColor = .black
        button.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        label.font = .systemFont(ofSize: 16, weight: .medium)
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
        user = databaseService.getUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        user = databaseService.getUserData()
        setUserData()
    }
    
    //MARK: - flow funcs
    
    @objc private func nextButtonTapped() {
        let newViewController = ProfileSettingsVC()
        navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    
    @objc private func changePasswordButtonTapped() {
        
        if user?.isGoogleUser == false {
            var validationResult: Bool = false
            let alert = alertManager.showAlertChangePassword(title: "change password", message: "Please enter new password") { [self] (result, email, oldPassword, newPassword, confNewPassword) in
                switch result {
                case true:
                    if let email = email,
                       let oldPassword = oldPassword,
                       let newPassword = newPassword,
                       let confNewPassword = confNewPassword {
                        do {
                            validationResult = try self.validator.checkString(stringType: .email, string: email, stringForMatching: nil)
                            validationResult = try self.validator.checkString(stringType: .password , string: oldPassword, stringForMatching: nil)
                            validationResult = try self.validator.checkString(stringType: .password, string: newPassword, stringForMatching: nil)
                            validationResult = try self.validator.checkString(stringType: .password, string: confNewPassword, stringForMatching: nil)
                            validationResult = try self.validator.checkString(stringType: .passwordMatch, string: newPassword, stringForMatching: confNewPassword)
                        } catch {
                            self.present(self.alertManager.showAlert(title: "Error!", message: error.localizedDescription), animated: true)
                        }
                        if validationResult == true {
                            self.changePassword(email: email, oldPassword: oldPassword, newPassword: newPassword)
                        }
                    }
                case false:
                    return
                }
            }
            present(alert, animated: true)
        } else {
            present(alertManager.showAlert(title: "Warning!", message: "You can't change Google user password!"), animated: true)
        }
    }
    
    @objc private func forgotPasswordButtonTapped() {
        
        if user?.isGoogleUser == false {
            
            var validationResult: Bool = false
            let alert = alertManager.showAlertRememberPassword(title: "Forgot password?", message: "Enter e-mail address and wait letter)", completionBlock: { (result, email) in
                switch result {
                case true:
                    if let email = email {
                        do {
                            validationResult = try self.validator.checkString(stringType: .email, string: email, stringForMatching: nil)
                        } catch {
                            self.present(self.alertManager.showAlert(title: "Error!", message: error.localizedDescription), animated: true)
                        }
                        if validationResult == true {
                            self.rememberPassword(email: email)
                        }
                    }
                    
                case false:
                    return
                }
            })
            present(alert, animated: true)
            
        } else {
            present(alertManager.showAlert(title: "Warning!", message: "You can't restore Google user password!"), animated: true)
        }
        
    }
    
    
    
    @objc private func darkModeButtonTapped() {
    }
    
    @objc private func logOutButtonTaped() {
        
//        authManager.signOutFaster { result in
//            switch result {
//            case .success(let result):
//                if result == true {
//                    let loginVC = LoginViewController()
//                    loginVC.modalPresentationStyle = .fullScreen
//                    self.navigationController?.pushViewController(loginVC, animated: true)
//                }
//            case .failure(let error):
//                self.present(self.alertManager.showAlert(title: "Error!", message: error.localizedDescription), animated: true)
//            }
//        }
        
        guard let user = user else { return }
        
        authManager.signOutFromGoogle(email: user.userEmail)
        
        authManager.signOut(email: user.userEmail) { result in
            switch result {
            case .success(let result):
                if result == true {
                    let loginVC = LoginViewController()
                    loginVC.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(loginVC, animated: true)
                }
            case .failure(let error):
                self.present(self.alertManager.showAlert(title: "Error!", message: error.localizedDescription), animated: true)
            }
            
            
        }
        
        
        
    }
    
    @objc func switchStateDidChange(_ sender: UISwitch)
    {
        if (sender.isOn == true){
            print("UISwitch state is now ON")
            UserDefaults.standard.setValue(Theme.dark.rawValue, forKey: "theme")
        }
        else{
            print("UISwitch state is now Off")
            UserDefaults.standard.setValue(Theme.light.rawValue, forKey: "theme")
        }
    }
    
    func changePassword(email: String, oldPassword: String, newPassword: String) {
        authManager.signIn(email: email, password: oldPassword, completionBlock: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.authManager.changePassword(newPassword: newPassword, completionBlock: { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(_):
                        DispatchQueue.main.async {
                            let loginVC = LoginViewController()
                            loginVC.modalPresentationStyle = .fullScreen
                            self.navigationController?.pushViewController(loginVC, animated: true)
                        }
                        
                    case .failure(let error):
                        self.present(self.alertManager.showAlert(title: "Error!", message: error.localizedDescription), animated: true)
                    }
                })
            case .failure(let error):
                self.present(self.alertManager.showAlert(title: "Error!", message: error.localizedDescription), animated: true)
            }
        })
    }
    
    func rememberPassword(email: String) {
        authManager.restorePassword(email: email, completionBlock: { [weak self] result in
            guard let self = self else { return }
            switch result {
                
            case .success(_):
                self.present(self.alertManager.showAlert(title: "Complete!", message: "Password was send on your email address"), animated: true)
            case .failure(let error):
                self.present(self.alertManager.showAlert(title: "Error!", message: error.localizedDescription), animated: true)
            }
        })
    }
    
    func setUserData() {
        if let user = user {
            profileNameLabel.text = String("\(user.userFirstName) \(user.userLastName)")
            nickNameLabel.text = user.userEmail
        }
        let style = UIScreen.main.traitCollection.userInterfaceStyle
        switch style {
        case .unspecified:
            customSwitch.isOn = false
        case .light:
            customSwitch.isOn = false
        case .dark:
            customSwitch.isOn = true
//        default:
//            customSwitch.isOn = false
        }
        
//        let theme = UserDefaults.standard.object(forKey: "theme") as! String
//        switch theme {
//        case "light":
//            customSwitch.isOn = false
//        case "dark":
//            customSwitch.isOn = true
//        default:
//            customSwitch.isOn = false
//        }
        
    }
    
}

//MARK: - extensions setupViews

extension ProfileViewController {
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(navigationBar)
        
        view.addSubview(profileImageView)
        
        profileStackView = UIStackView(customArrangedSubviews: [profileNameLabel, nickNameLabel], axis: .vertical, spacing: 2)
        
        view.addSubview(profileStackView)
        
        view.addSubview(personalInfoLabel)
        
        view.addSubview(ProfileButton)
        view.addSubview(nextButton)
        
        view.addSubview(securityInfoLabel)
        
        view.addSubview(changePasswordButton)
        
        view.addSubview(forgotPasswordButton)
        
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
            ProfileButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            ProfileButton.topAnchor.constraint(equalTo: personalInfoLabel.bottomAnchor, constant: 16),
            ProfileButton.widthAnchor.constraint(equalToConstant: 327),
            ProfileButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.centerYAnchor.constraint(equalTo: ProfileButton.centerYAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            nextButton.widthAnchor.constraint(equalToConstant: 24),
            nextButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            securityInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            securityInfoLabel.topAnchor.constraint(equalTo: ProfileButton.bottomAnchor, constant: 24),
            securityInfoLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            changePasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            changePasswordButton.topAnchor.constraint(equalTo: securityInfoLabel.bottomAnchor, constant: 16),
            changePasswordButton.widthAnchor.constraint(equalToConstant: 327),
            changePasswordButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        
        NSLayoutConstraint.activate([
            forgotPasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            forgotPasswordButton.topAnchor.constraint(equalTo: changePasswordButton.bottomAnchor, constant: 32),
            forgotPasswordButton.widthAnchor.constraint(equalToConstant: 327),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        
        NSLayoutConstraint.activate([
            darkModeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            darkModeButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 32),
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
