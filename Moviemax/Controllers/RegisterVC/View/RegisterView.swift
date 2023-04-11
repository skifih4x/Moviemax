//
//  RegisterView.swift
//  Moviemax
//
//  Created by Sergey on 07.04.2023.
//

import Foundation
import UIKit
import SnapKit

protocol RegisterViewDelegate: AnyObject {
    
    func registerView(didSignUpButtonTapped button: UIButton)
    func registerView(didLogInButtonTapped button: UIButton)
    
}

class RegisterView: CustomView {
    
    //MARK: - Variables
    
    weak var delegate: RegisterViewDelegate?
    
    //MARK: - UIView / UIStackView
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor.systemBackground
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    lazy var backgroundView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 430, height: 1200))
        view.backgroundColor = .systemBackground
        return view
    }()
    
    lazy var verticalStack: UIStackView = {
        let stack = UIStackView(frame: CGRect(x: 0, y: 0, width: 414, height: 1200))
        stack.axis = .vertical
        stack.spacing = 10.0
        stack.alignment = .fill
        stack.contentMode = .scaleAspectFill
        stack.distribution = .fillProportionally
        [titleLabel,
        smallTitle,
        firstNameLabel,
        fNameView,
        lastNameLabel,
        lNameView,
        emailLabel,
        emailView,
        passwordLabel,
        passwordView,
        confirmPassLabel,
        confPasswordView,
        signUpButton].forEach {
            stack.addArrangedSubview($0)
        }
        return stack
    }()
    
    lazy var fNameView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 327, height: 52))
        view.backgroundColor = UIColor.systemGray4
        view.layer.cornerRadius = 26
        return view
    }()
    
    lazy var lNameView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 327, height: 52))
        view.backgroundColor = UIColor.systemGray4
        view.layer.cornerRadius = 26
        return view
    }()
    
    lazy var emailView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 327, height: 52))
        view.backgroundColor = UIColor.systemGray4
        view.layer.cornerRadius = 26
        return view
    }()
    
    lazy var passwordView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 327, height: 52))
        view.backgroundColor = UIColor.systemGray4
        view.layer.cornerRadius = 26
        return view
    }()
    
    lazy var confPasswordView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 327, height: 52))
        view.backgroundColor = UIColor.systemGray4
        view.layer.cornerRadius = 26
        return view
    }()
    
    //MARK: - UILabel
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 264, height: 32))
        label.text = "Complet your account"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var smallTitle: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 183, height: 22))
        label.text = "create new user"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var firstNameLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 72, height: 22))
        label.text = "First Name"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemGray3
        label.textAlignment = .left
        return label
    }()
    
    lazy var lastNameLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 71, height: 22))
        label.text = "Last Name"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemGray3
        label.textAlignment = .left
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 44, height: 22))
        label.text = "E-mail"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemGray3
        label.textAlignment = .left
        return label
    }()
    
    lazy var passwordLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 67, height: 22))
        label.text = "Password"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemGray3
        label.textAlignment = .left
        return label
    }()
    
    lazy var confirmPassLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 124, height: 22))
        label.text = "Confirm password"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemGray3
        label.textAlignment = .left
        return label
    }()
    
    
    lazy var logInLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 254, height: 24))
        label.text = "Already have an account?"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemGray
        label.textAlignment = .left
        return label
    }()
    
    
    //MARK: - UITextField
    
    lazy var fNameTextField: UITextField = {
        let text = UITextField(frame: CGRect(x: 0, y: 0, width: 327, height: 52))
        text.placeholder = "Enter first name"
        text.borderStyle = .none
        text.backgroundColor = .clear
        text.textContentType = .name
        return text
    }()
    
    lazy var lNameTextField: UITextField = {
        let text = UITextField(frame: CGRect(x: 0, y: 0, width: 327, height: 52))
        text.placeholder = "Enter last name"
        text.borderStyle = .none
        text.backgroundColor = .clear
        text.textContentType = .name
        return text
    }()
    
    lazy var emailTextField: UITextField = {
        let text = UITextField(frame: CGRect(x: 0, y: 0, width: 327, height: 52))
        text.placeholder = "Enter your email"
        text.borderStyle = .none
        text.backgroundColor = .clear
        text.textContentType = .emailAddress
        return text
    }()
    
    lazy var passwordTextField: UITextField = {
        let text = UITextField(frame: CGRect(x: 0, y: 0, width: 327, height: 52))
        text.placeholder = "Enter your password"
        text.borderStyle = .none
        text.backgroundColor = .clear
        text.textContentType = .password
        text.isSecureTextEntry = true
        return text
    }()
    
    lazy var confPasswordTextField: UITextField = {
        let text = UITextField(frame: CGRect(x: 0, y: 0, width: 327, height: 52))
        text.placeholder = "Confirm your password"
        text.borderStyle = .none
        text.backgroundColor = .clear
        text.textContentType = .password
        text.isSecureTextEntry = true
        return text
    }()
    
    //MARK: - UIButton
    
    
    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 327, height: 56)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(named: "backgroundColor")
        button.layer.cornerRadius = 28
        button.addTarget(self, action: #selector(didTappedSignUpButton), for: .touchUpInside)
        return button
    }()
    
    lazy var logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.titleLabel?.textAlignment = .left
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(didTappedLogInButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - SetupViews
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        fNameView.addSubview(fNameTextField)
        lNameView.addSubview(lNameTextField)
        emailView.addSubview(emailTextField)
        passwordView.addSubview(passwordTextField)
        confPasswordView.addSubview(confPasswordTextField)
        backgroundView.addSubview(verticalStack)
        backgroundView.addSubview(logInLabel)
        backgroundView.addSubview(logInButton)
    }
    
    //MARK: - LayoutViews
    
    override func layoutViews() {
        super.layoutViews()
        
        setupConstraints()
        
    }
    
    //MARK: - Setup Constraint
    
    func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints { make in
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(scrollView.snp.height).priority(.init(450))
        }
        
        verticalStack.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.top)
            make.leading.equalTo(backgroundView.snp.leading)
            make.trailing.equalTo(backgroundView.snp.trailing)
            make.width.equalToSuperview()
            make.height.equalTo(847)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(264)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(60)
            
        }
        
        smallTitle.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.width.equalTo(183)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
        }
        
        firstNameLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.width.equalTo(72)
            make.top.equalTo(smallTitle.snp.bottom).offset(30)
            make.bottom.equalTo(fNameView.snp.top).offset(-10)
        }
        
        
        fNameTextField.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.leading.equalTo(fNameView.snp.leading).offset(10)
            make.trailing.equalTo(fNameView.snp.trailing).offset(-10)
            make.centerY.equalTo(fNameView)
        }
        
        fNameView.snp.makeConstraints { make in
            make.height.equalTo(fNameTextField.snp.height)
            make.leading.equalTo(scrollView.snp.leading).offset(24)
            make.trailing.equalTo(scrollView.snp.trailing).offset(-24)
            make.top.equalTo(firstNameLabel.snp.bottom).offset(10)
            make.bottom.equalTo(lastNameLabel.snp.top).offset(-43)
        }
        
        lastNameLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.width.equalTo(71)
            make.top.equalTo(fNameView.snp.bottom).offset(43)
            make.bottom.equalTo(lNameView.snp.top).offset(-10)
        }
        
        lNameTextField.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.leading.equalTo(lNameView.snp.leading).offset(10)
            make.trailing.equalTo(lNameView.snp.trailing).offset(-10)
            make.centerY.equalTo(lNameView)
        }
        
        lNameView.snp.makeConstraints { make in
            make.height.equalTo(lNameTextField.snp.height)
            make.leading.equalTo(scrollView.snp.leading).offset(24)
            make.trailing.equalTo(scrollView.snp.trailing).offset(-24)
            make.top.equalTo(lastNameLabel.snp.bottom).offset(10)
            make.bottom.equalTo(emailLabel.snp.top).offset(-43)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.width.equalTo(44)
            make.top.equalTo(lNameView.snp.bottom).offset(43)
            make.bottom.equalTo(emailView.snp.top).offset(-10)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.leading.equalTo(emailView.snp.leading).offset(10)
            make.trailing.equalTo(emailView.snp.trailing).offset(-10)
            make.centerY.equalTo(emailView)
        }
        
        emailView.snp.makeConstraints { make in
            make.height.equalTo(emailTextField.snp.height)
            make.leading.equalTo(scrollView.snp.leading).offset(24)
            make.trailing.equalTo(scrollView.snp.trailing).offset(-24)
            make.top.equalTo(emailLabel.snp.bottom).offset(43)
            make.bottom.equalTo(passwordLabel.snp.top).offset(-43)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.width.equalTo(67)
            make.top.equalTo(emailView.snp.bottom).offset(43)
            make.bottom.equalTo(passwordView.snp.top).offset(-10)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.leading.equalTo(passwordView.snp.leading).offset(10)
            make.trailing.equalTo(passwordView.snp.trailing).offset(-10)
            make.centerY.equalTo(passwordView)
        }
        
        passwordView.snp.makeConstraints { make in
            make.height.equalTo(passwordTextField.snp.height)
            make.leading.equalTo(scrollView.snp.leading).offset(24)
            make.trailing.equalTo(scrollView.snp.trailing).offset(-24)
            make.top.equalTo(passwordLabel.snp.bottom).offset(43)
            make.bottom.equalTo(confirmPassLabel.snp.top).offset(-43)
        }
        
        confirmPassLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.width.equalTo(124)
            make.top.equalTo(passwordView.snp.bottom).offset(43)
            make.bottom.equalTo(confPasswordView.snp.top).offset(-10)
        }
        
        confPasswordTextField.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.leading.equalTo(confPasswordView.snp.leading).offset(10)
            make.trailing.equalTo(confPasswordView.snp.trailing).offset(-10)
            make.centerY.equalTo(confPasswordView)
        }
        
        confPasswordView.snp.makeConstraints { make in
            make.height.equalTo(confPasswordTextField.snp.height)
            make.leading.equalTo(scrollView.snp.leading).offset(24)
            make.trailing.equalTo(scrollView.snp.trailing).offset(-24)
            make.top.equalTo(confirmPassLabel.snp.bottom).offset(43)
            make.bottom.equalTo(signUpButton.snp.top).offset(-65)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.leading.equalTo(scrollView.snp.leading).offset(24)
            make.trailing.equalTo(scrollView.snp.trailing).offset(-24)
            make.top.equalTo(confPasswordView.snp.bottom).offset(65)
            make.height.equalTo(56)
        }
        
        logInLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(200)
            make.leading.equalTo(scrollView.snp.leading).offset(40)
            make.bottom.equalTo(backgroundView.snp.bottom).offset(-40)
        }
        
        logInButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(80)
            make.leading.equalTo(logInLabel.snp.trailing).offset(2)
            make.top.equalTo(logInLabel.snp.top)
            make.bottom.equalTo(backgroundView.snp.bottom).offset(-40)
        }
        
    }
    
    
}


extension RegisterView {
    
    @objc func didTappedSignUpButton(_ button: UIButton) {
        delegate?.registerView(didSignUpButtonTapped: button)
    }
    
    @objc func didTappedLogInButton(_ button: UIButton) {
        delegate?.registerView(didLogInButtonTapped: button)
    }
    
}


