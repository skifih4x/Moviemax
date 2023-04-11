//
//  RegisterViewController.swift
//  Moviemax
//
//  Created by Sergey on 07.04.2023.
//

import Foundation
import UIKit


class RegisterViewController: CustomViewController<RegisterView> {
    
    
    
    let authManager = AuthManager()
    let alertManager = AlertControllerManager()
    let validator = ValidatorClass()
    
    var canTransitionToLarge = false
    var canTransitionToSmall = true
    
    override func loadView() {
        super.loadView()
        
        view = RegisterView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView.delegate = self
        customView.scrollView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.hidesBottomBarWhenPushed = false
        
    }
    
}

extension RegisterViewController: RegisterViewDelegate {
    func registerView(didSignUpButtonTapped button: UIButton) {
        var validateResult: Bool = false
        if customView.fNameTextField.text != "" && customView.fNameTextField.text != nil,
           customView.lNameTextField.text != "" && customView.lNameTextField.text != nil,
           customView.emailTextField.text != "" && customView.emailTextField.text != nil,
           customView.passwordTextField.text != "" && customView.passwordTextField.text != nil,
           customView.confPasswordTextField.text != "" && customView.confPasswordTextField.text != nil
        {
            let userFirstName = customView.fNameTextField.text!
            let userLastName = customView.lNameTextField.text!
            let userEmail = customView.emailTextField.text!
            let userPassword = customView.passwordTextField.text!
            let userConfirmPass = customView.confPasswordTextField.text!
            
            do {
                validateResult = try validator.checkString(stringType: .userName, string: userFirstName, stringForMatching: nil)
                validateResult = try validator.checkString(stringType: .userName, string: userLastName, stringForMatching: nil)
                validateResult = try validator.checkString(stringType: .email, string: userEmail, stringForMatching: nil)
                validateResult = try validator.checkString(stringType: .password, string: userPassword, stringForMatching: nil)
                validateResult = try validator.checkString(stringType: .password, string: userConfirmPass, stringForMatching: nil)
                validateResult = try validator.checkString(stringType: .passwordMatch, string: userPassword, stringForMatching: userConfirmPass)
            } catch {
                present(alertManager.showAlert(title: "Warning!", message: error.localizedDescription), animated: true)
            }
            
            if validateResult == true {
                authManager.createUser(userFirstName: userFirstName, userLastName: userLastName, email: userEmail, password: userPassword) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let user):
                        print(user)
                        var homeVC: MainTabBarController!
                        homeVC = MainTabBarController()
                        homeVC.modalPresentationStyle = .fullScreen
                        present(homeVC, animated: true)
                        
                    case .failure(let error):
                        present(self.alertManager.showAlert(title: "Error!", message: error.localizedDescription), animated: true)
                    }
                }
            }
            
        } else {
            present(alertManager.showAlert(title: "Warning", message: ValidateInputError.emptyString.localizedDescription), animated: true)
        }
    }
    
    func registerView(didLogInButtonTapped button: UIButton) {
        if let navigationVC = navigationController {
            
            navigationVC.popViewController(animated: true)
        }
    }
    
}

extension RegisterViewController: UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        
        if canTransitionToLarge && scrollView.contentOffset.y <= 0 {
            navigationController?.navigationBar.topItem?.title = ""
            canTransitionToLarge = false
            canTransitionToSmall = true
        }
        else if canTransitionToSmall && scrollView.contentOffset.y > 0 {
            navigationController?.navigationBar.topItem?.title = "Complet your account"
            canTransitionToLarge = true
            canTransitionToSmall = false
        }
        
    }
    
}

