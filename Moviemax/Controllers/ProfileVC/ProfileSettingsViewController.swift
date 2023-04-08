//
//  ProfileSettingsViewController.swift
//  Moviemax
//
//  Created by Даниил Петров on 06.04.2023.
//

/*
import UIKit

class ProfileSettingsViewController: UIViewController {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileImage")
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let personalInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Personal Info"
        label.font = label.font.withSize(12)
        label.textColor = .systemGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let firstNameTextField = CustomTextField(placeholder: "Andy")
    let lastNameTextField = CustomTextField(placeholder: "Lexsian")
    let emailTextField = CustomTextField(placeholder: "Andylexian22@gmail.com")
    let dateOfBirthTextField = CustomTextField(placeholder: "24 February 1996")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Profile"
        
        let customButton = CustomBarButtonItem(target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = customButton
        
        setupViews()
        setConstraints()
    }
    
    
    
    
    
    
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}

extension ProfileSettingsViewController {
    
    class CustomTextField: UITextField {
        
        init(placeholder: String) {
            super.init(frame: .zero)
            
            self.placeholder = placeholder
            self.font = UIFont.systemFont(ofSize: 16)
            self.textColor = #colorLiteral(red: 0.3176470588, green: 0.3058823529, blue: 0.7137254902, alpha: 1)

            
            self.backgroundColor = .none
            self.tintColor = #colorLiteral(red: 0.3176470588, green: 0.3058823529, blue: 0.7137254902, alpha: 1)
            self.layer.cornerRadius = 32
            self.layer.borderWidth = 1
            self.layer.borderColor = #colorLiteral(red: 0.3176470588, green: 0.3058823529, blue: 0.7137254902, alpha: 1)
            self.translatesAutoresizingMaskIntoConstraints = false
            
            
   
     
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}


extension ProfileViewController {
    
    private func setupViews() {
        view.addSubview(firstNameTextField)
    }
    
}
extension ProfileViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            firstNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            firstNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 124),
            firstNameTextField.widthAnchor.constraint(equalToConstant: 56),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 56)
        ])
        
    }
    
    
}
*/
