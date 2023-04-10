//
//  LoginViewController.swift
//  Moviemax
//
//  Created by Sergey on 05.04.2023.
//

import Foundation
import UIKit
import GoogleSignIn


class LoginViewController: CustomViewController<LoginView> {
    
    let authManager = AuthManager()
    let validationManager = ValidatorClass()
    let alertManager = AlertControllerManager()
    var userEmail: String = ""
    
    override func loadView() {
        super.loadView()
        
        view = LoginView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customView.delegate = self
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.isDarkMode == true {
            customView.googleButton.colorScheme = GIDSignInButtonColorScheme.dark
        } else {
            customView.googleButton.colorScheme = GIDSignInButtonColorScheme.light
        }
        self.hidesBottomBarWhenPushed = true
        self.reloadInputViews()
    }
    
}

extension LoginViewController: LoginViewDelegate {
    
    func loginView(didTappedLoginButton button: UIButton) {
        
        var validateResult = false
        if userEmail == "" {
            do {
                validateResult =  try validationManager.checkString(stringType: .email, string: customView.emailTextField.text ?? "", stringForMatching: nil)
            } catch {
                present(alertManager.showAlert(title: "Error", message: error.localizedDescription), animated: true)
            }
            
            if validateResult == true {
                userEmail = customView.emailTextField.text!
                customView.emailLabel.text = "Password"
                customView.emailTextField.text = ""
                customView.emailTextField.placeholder = "Enter password"
                customView.emailTextField.textContentType = .password
                customView.emailTextField.isSecureTextEntry = true
                customView.continueButton.setTitle("Enter password", for: .normal)
                validateResult = false
            }
        }
        else {
            do {
                validateResult =  try validationManager.checkString(stringType: .password, string: customView.emailTextField.text ?? "", stringForMatching: nil)
            } catch {
                present(alertManager.showAlert(title: "Error", message: error.localizedDescription), animated: true)
            }
            if validateResult == true {
                authManager.signIn(email: userEmail, password: customView.emailTextField.text!) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let user):
                        print(user)
                        var homeVC: HomeViewController!
                        homeVC = HomeViewController()
                        self.navigationController?.pushViewController(homeVC, animated: true)
                    case .failure(let error):
                        present(self.alertManager.showAlert(title: "Error!", message: error.localizedDescription), animated: true)
                    }
                }
            }
        }
        
        
    }
    
    func loginView(didTappedRegisterButton button: UIButton) {
        if let navigationVC = navigationController {
            let registerVC = RegisterViewController()
            navigationVC.pushViewController(registerVC, animated: true)
        }
    }
    
    func loginView(didTappedGoogleSignIn button: GIDSignInButton) {
        authManager.signInWithGoogle(view: self) { result in
            switch result {
            case .success(let user):
                print(user)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}

extension UIViewController {
    var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        }
        else {
            return false
        }
    }

}
