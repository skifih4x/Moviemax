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
    func loginView(didTappedSignInButton button: UIButton)
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
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var textFieldView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 327, height: 52))
        view.backgroundColor = .systemGray
        view.layer.cornerRadius = view.frame.height / 2
        return view
    }()
    
    lazy var horizontalStackView: UIStackView = {
        let stack = UIStackView(frame: CGRect(x: 0, y: 0, width: 414, height: 300))
        stack.axis = .horizontal
        stack.spacing = 10.0
        stack.alignment = .fill
        stack.contentMode = .scaleAspectFill
        stack.distribution = .fillProportionally
        [emailLabel,
        emailTextField,
        continueButton,
        separatorLabel,
        googleButton,
        registerStack].forEach {
            stack.addArrangedSubview($0)
        }
        return stack
    }()
    
    lazy var registerStack: UIStackView = {
        let stack = UIStackView(frame: CGRect(x: 0, y: 0, width: 300, height: 56))
        stack.axis = .vertical
        stack.spacing = 10.0
        stack.alignment = .fill
        stack.contentMode = .scaleAspectFill
        stack.distribution = .fillProportionally
        [signupLabel,
        registerButton].forEach {
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
        label.text = "Please login or singup"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 37, height: 22))
        label.text = "E-mail:"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var separatorLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 22))
        label.text = "Or continue with"
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var signupLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 245, height: 24))
        label.text = "Don`t have an account?"
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - UITextField
    
    lazy var emailTextField: UITextField = {
        let text = UITextField(frame: CGRect(x: 0, y: 0, width: 327, height: 40))
        text.placeholder = "Enter your Email address"
        text.borderStyle = .none
        text.backgroundColor = .systemGray
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
        button.frame = CGRect(x: 0, y: 0, width: 327, height: 56)
        button.layer.cornerRadius = 28
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray.cgColor
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(UIColor.systemGray, for: .normal)
        button.addTarget(self, action: #selector(didTappedRegisterButton), for: .touchUpInside)
        return button
    }()
    
    
    
     required init?(coder: NSCoder) {
        super .init(coder: coder)
    }
    override func setViews() {
        super.setViews()
    }
    
    override func layoutViews() {
        super.layoutViews()
    }
}

extension LoginView {
    @objc func didTappedLoginButton(_ button: UIButton) {
        
    }
    
    @objc func didTappedRegisterButton(_ button: UIButton) {
        
    }
}
