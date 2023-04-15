//
//  LoginView.swift
//  Moviemax
//
//  Created by Sergey on 05.04.2023.
//

import Foundation
import SnapKit
import UIKit
import FirebaseCore
import GoogleSignIn


protocol LoginViewDelegate: AnyObject {
    func loginView(didTappedLoginButton button: UIButton)
    func loginView(didTappedRegisterButton button: UIButton)
    func loginView(didTappedGoogleSignIn button: GIDSignInButton)
}

class LoginView: CustomView {
    
    weak var delegate: LoginViewDelegate?
    
    //MARK: - UIView / UIStackView
    
    lazy var backgroundView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 414, height: 500))
        view.backgroundColor = UIColor(named: "backgroundColor")
        return view
    }()
    
    lazy var loginView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 414, height: 400))
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 35
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var textFieldView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 327, height: 52))
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 24
        return view
    }()
    
    lazy var verticalStackView: UIStackView = {
        let stack = UIStackView(frame: CGRect(x: 0, y: 0, width: 414, height: 300))
        stack.axis = .vertical
        stack.spacing = 50.0
        stack.alignment = .fill
        stack.contentMode = .scaleAspectFill
        stack.distribution = .fillProportionally
        [emailLabel,
        textFieldView,
        continueButton,
        separatorLabel,
        googleButton
        ].forEach {
            stack.addArrangedSubview($0)
        }
        return stack
    }()
    

    
    //MARK: - UILabel
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 184, height: 32))
        label.text = "Login"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var underTitleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 209, height: 24))
        label.text = "Please login or SignUp"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 37, height: 22))
        label.text = "E-mail:"
        label.font = UIFont.systemFont(ofSize: 14, weight: .black)
        label.textColor = .systemGray
        label.textAlignment = .left
        return label
    }()
    
    lazy var separatorLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 22))
        label.text = "Or continue with"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var signupLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 245, height: 24))
        label.text = "Don`t have an account?"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemGray
        label.textAlignment = .right
        return label
    }()
    
    //MARK: - UITextField
    
    lazy var emailTextField: UITextField = {
        let text = UITextField(frame: CGRect(x: 0, y: 0, width: 327, height: 40))
        text.placeholder = "Enter your Email address"
        text.borderStyle = .none
        text.backgroundColor = .clear
        return text
    }()
    
    //MARK: - UIButton
    
    lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 327, height: 56)
        button.setTitle("Continue with Email", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(named: "backgroundColor")
        button.layer.cornerRadius = 28
        button.addTarget(self, action: #selector(didTappedLoginButton), for: .touchUpInside)
        return button
    }()
    
    lazy var googleButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.style = GIDSignInButtonStyle.wide
        button.frame = CGRect(x: 0, y: 0, width: 327, height: 80)
        button.layer.borderWidth = 0
        button.addTarget(self, action: #selector(didTappedGoogleSignIn), for: .touchUpInside)
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.titleLabel?.textAlignment = .left
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(didTappedRegisterButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Setup views
    
    override func setupViews() {
        super.setupViews()
    
        addSubview(backgroundView)
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(underTitleLabel)
        backgroundView.addSubview(loginView)
        loginView.addSubview(verticalStackView)
        textFieldView.addSubview(emailTextField)
        loginView.addSubview(registerButton)
        loginView.addSubview(signupLabel)
        
    }
    
    override func layoutViews() {
        super.layoutViews()
        setupConstraints()
    }
    
    func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundView)
            make.height.equalTo(32)
            make.width.equalTo(184)
            make.top.equalTo(backgroundView.snp.top).offset(74)
        }
        
        underTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundView)
            make.height.equalTo(24)
            make.width.equalTo(209)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        loginView.snp.makeConstraints { make in
            make.leading.equalTo(backgroundView.snp.leading)
            make.trailing.equalTo(backgroundView.snp.trailing)
            make.bottom.equalTo(backgroundView.snp.bottom)
            make.top.equalTo(underTitleLabel.snp.bottom).offset(60)
        }
        
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.leading.equalTo(textFieldView.snp.leading).offset(10)
            make.trailing.equalTo(textFieldView.snp.trailing).offset(-10)
            make.centerY.equalTo(textFieldView)
        }
        
        textFieldView.snp.makeConstraints { make in
            make.height.equalTo(emailTextField.snp.height)
            make.leading.equalTo(backgroundView.snp.leading).offset(24)
            make.trailing.equalTo(backgroundView.snp.trailing).offset(-24)
            make.top.equalTo(emailLabel.snp.bottom).offset(43)
            make.bottom.equalTo(continueButton.snp.top).offset(-43)
            
        }
        
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(loginView.snp.top).offset(28)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(400)
        }
        
        separatorLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.centerX.equalTo(loginView)
            make.trailing.equalTo(loginView.snp.trailing)
            make.leading.equalTo(loginView.snp.leading)
            
        }
        
        emailLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.leading.equalTo(loginView.snp.leading).offset(15)
            make.trailing.equalTo(loginView.snp.trailing).offset(-15)
        }
        
        continueButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.leading.equalTo(backgroundView.snp.leading).offset(24)
            make.trailing.equalTo(backgroundView.snp.trailing).offset(-24)
            make.centerY.equalToSuperview()
            
        }
        
        googleButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.leading.equalTo(backgroundView.snp.leading).offset(24)
            make.trailing.equalTo(backgroundView.snp.trailing).offset(-24)
        }
        
        signupLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(200)
            make.leading.equalTo(loginView.snp.leading).offset(40)
            make.bottom.equalTo(loginView.snp.bottom).offset(-200)
        }
        
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(80)
            make.leading.equalTo(signupLabel.snp.trailing).offset(2)
            make.top.equalTo(signupLabel.snp.top)
        }
        
    }
    
}

extension LoginView {
    @objc func didTappedLoginButton(_ button: UIButton) {
        delegate?.loginView(didTappedLoginButton: button)
    }
    
    @objc func didTappedRegisterButton(_ button: UIButton) {
        delegate?.loginView(didTappedRegisterButton: button)
    }
    
    @objc func didTappedGoogleSignIn(_ button: GIDSignInButton) {
        delegate?.loginView(didTappedGoogleSignIn: button)
    }
}
