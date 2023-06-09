//
//  ProfileSettingsVC.swift
//  Moviemax
//
//  Created by Даниил Петров on 10.04.2023.
//

import UIKit

final class ProfileSettingsVC: UIViewController {
    
    var imagePicker: ImagePicker!
//    private let popupViewController = ChangeAvatarViewController()
    private var databaseService = RealmService.userAuth
    var user: UserAuthData?
    let alertManager = AlertControllerManager()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemChromeMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        return blurEffectView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "BackButton"), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileImage")
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        

        return imageView
    }()

    private lazy var editAvatar: UIButton = {
        let button = UIButton(type: .system)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ChangeProfilePhoto")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        
        button.setImage(imageView.image, for: .normal)
        button.addTarget(self, action: #selector(changeAvatarButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Labels
    private lazy var firstNameLabel = makeLabel(text: "First Name")
    private lazy var lastNameLabel = makeLabel(text: "Last Name")
    private lazy var emailLabel = makeLabel(text: "E-mail")
    private lazy var dateOfBirthLabel = makeLabel(text: "Date of Birth")
    private lazy var genderLabel = makeLabel(text: "Gender")
    private lazy var locationLabel = makeLabel(text: "Location")
    
    //MARK: - TextFields
    private lazy var firstNameTextField = makeTextField(withPlaceholder: "First Name")
    private lazy var lastNameTextField = makeTextField(withPlaceholder: "Last Name")
    private lazy var emailTextField = makeTextField(withPlaceholder: "E-mail")
    private lazy var dateOfBirthTextField = makeTextFieldWithCalendar(withPlaceholder: "Date of Birth")
    private lazy var locationTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .lightGray
        textView.layer.cornerRadius = 24
        textView.layer.borderWidth = 1
        textView.layer.borderColor = #colorLiteral(red: 0.3179999888, green: 0.3059999943, blue: 0.7139999866, alpha: 1).cgColor
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = self
        textView.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    //MARK: - Buttons

    private lazy var maleButton = GenderCustomButton(type: .male) {
        print("maleButtonTapped")
    }
    private lazy var femaleButton = GenderCustomButton(type: .female) {
        print("femaleButtonTapped")
    }
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
//        button.isEnabled = false
        button.setTitle("Save Changes", for: .normal)
        
        button.titleLabel?.font = button.titleLabel?.font.withSize(16)
        button.setTitleColor(button.isEnabled ? .black : .systemGray, for: .normal)
        button.layer.cornerRadius = 24
        button.backgroundColor = button.isEnabled ? #colorLiteral(red: 0.3179999888, green: 0.3059999943, blue: 0.7139999866, alpha: 1) : .systemGray6
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
//MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let customBarButton = CustomBarButtonItem(target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = customBarButton
        navigationItem.title = "Profile"

        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
//        setupBlur()
        user = databaseService.getUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        user = databaseService.getUserData()
        setUserData()
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func changeAvatarButtonTapped(_ sender: UIButton) {
        print(#function)
        
        
//        self.visualEffectView.alpha = 1.0
        self.imagePicker.present(from: sender)
        
//        let popupViewController = ChangeAvatarViewController()
//
//        addChild(popupViewController)
//        view.addSubview(popupViewController.view)
//        popupViewController.modalPresentationStyle = .overCurrentContext
//        popupViewController.view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
//        popupViewController.view.center = view.center
//        popupViewController.didMove(toParent: self)
//        popupViewController.showPopup()
    }
    
    @objc private func saveButtonPressed() {
        guard let user = user else { return }
        var isMale: Bool?
        if maleButton.isSelected || femaleButton.isSelected {
            isMale = maleButton.isSelected
        }
       
        let newUserData = UserAuthData(userFirstName: firstNameTextField.text ?? user.userFirstName,
                                       userLastName: lastNameTextField.text ?? user.userLastName,
                                       userEmail: emailTextField.text ?? user.userEmail,
                                       userPassword: user.userPassword,
                                       uid: user.uid,
                                       userImageUrl: user.userImageUrl,
                                       userImage: avatarImageView.image?.pngData(),
                                       isGoogleUser: user.isGoogleUser,
                                       userIsMale: isMale,
                                       userBDate: dateOfBirthTextField.text ?? user.userBDate,
                                       userLocation: locationTextView.text ?? user.userLocation)
        databaseService.deleteUser(with: user.userEmail)
        databaseService.saveUserData(newUserData)
        present(alertManager.showAlert(title: "Success!", message: "User data is save!"), animated: true)
    }

    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.9960784314, blue: 0.9960784314, alpha: 1)
        view.addSubview(backButton)
        view.addSubview(scrollView)
        scrollView.addSubview(avatarImageView)
        scrollView.addSubview(editAvatar)
        scrollView.addSubview(firstNameLabel)
        scrollView.addSubview(firstNameTextField)
        scrollView.addSubview(lastNameLabel)
        scrollView.addSubview(lastNameTextField)
        scrollView.addSubview(emailLabel)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(dateOfBirthLabel)
        scrollView.addSubview(dateOfBirthTextField)
        scrollView.addSubview(genderLabel)
        scrollView.addSubview(maleButton)
        scrollView.addSubview(femaleButton)
        scrollView.addSubview(locationLabel)
        scrollView.addSubview(locationTextView)
        scrollView.addSubview(saveButton)
        setupConstraints()
    }
    
    private func setupBlur() {

        visualEffectView.frame = view.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(visualEffectView)
        visualEffectView.alpha = 0
    }
    
    private func blurOut() {
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 0
            
        }
    }
    
    func setUserData() {
        if let user = user {
            firstNameTextField.text = user.userFirstName
            lastNameTextField.text = user.userLastName
            emailTextField.text = user.userEmail
            dateOfBirthTextField.text = user.userBDate
            if user.userIsMale == true {
                maleButton.isSelected = true
            }
            if user.userIsMale == false {
                femaleButton.isSelected = true
            }
            locationTextView.text = user.userLocation
            if user.userImageUrl != nil {
                
            } else {
                if user.userImage != nil {
                    avatarImageView.image = UIImage(data: user.userImage!)
                }
            }
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.Spacing.topSpacingForBackButton),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.Spacing.leadingStandartSpacing),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.Spacing.topSpacingForTitle),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            avatarImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: Constants.Size.avatarSize),
            avatarImageView.heightAnchor.constraint(equalToConstant: Constants.Size.avatarSize),
            
            editAvatar.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            editAvatar.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Constants.Spacing.leadingSpacingForEditAvatar.negative),
            editAvatar.widthAnchor.constraint(equalToConstant: Constants.Size.avatarEditSize),
            editAvatar.heightAnchor.constraint(equalToConstant: Constants.Size.avatarEditSize),
            
            firstNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: Constants.Spacing.topStandartSpacing),
            firstNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.Spacing.leadingStandartSpacing),
            
            firstNameTextField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: Constants.Spacing.topStandartSpacing.half),
            firstNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.Spacing.leadingStandartSpacing),
            firstNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constants.Spacing.trailingStandartSpacing.negative),
            firstNameTextField.heightAnchor.constraint(equalToConstant: Constants.Size.standartHeight),
            
            lastNameLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: Constants.Spacing.topStandartSpacing),
            lastNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.Spacing.leadingStandartSpacing),
            
            lastNameTextField.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: Constants.Spacing.topStandartSpacing.half),
            lastNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.Spacing.leadingStandartSpacing),
            lastNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constants.Spacing.trailingStandartSpacing.negative),
            lastNameTextField.heightAnchor.constraint(equalToConstant: Constants.Size.standartHeight),
            
            emailLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: Constants.Spacing.topStandartSpacing),
            emailLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.Spacing.leadingStandartSpacing),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: Constants.Spacing.topStandartSpacing.half),
            emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.Spacing.leadingStandartSpacing),
            emailTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constants.Spacing.trailingStandartSpacing.negative),
            emailTextField.heightAnchor.constraint(equalToConstant: Constants.Size.standartHeight),
            
            dateOfBirthLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: Constants.Spacing.topStandartSpacing),
            dateOfBirthLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.Spacing.leadingStandartSpacing),
            
            dateOfBirthTextField.topAnchor.constraint(equalTo: dateOfBirthLabel.bottomAnchor, constant: Constants.Spacing.topStandartSpacing.half),
            dateOfBirthTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.Spacing.leadingStandartSpacing),
            dateOfBirthTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constants.Spacing.trailingStandartSpacing.negative),
            dateOfBirthTextField.heightAnchor.constraint(equalToConstant: Constants.Size.standartHeight),
            
            genderLabel.topAnchor.constraint(equalTo: dateOfBirthTextField.bottomAnchor, constant: Constants.Spacing.topStandartSpacing),
            genderLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.Spacing.leadingStandartSpacing),
            
            maleButton.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: Constants.Spacing.topStandartSpacing.half),
            maleButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.Spacing.leadingStandartSpacing),
            
            femaleButton.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: Constants.Spacing.topStandartSpacing.half),
            femaleButton.leadingAnchor.constraint(equalTo: maleButton.trailingAnchor, constant: Constants.Spacing.spaceBetweenGenderButtons),
            femaleButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constants.Spacing.trailingStandartSpacing.negative),
            
            maleButton.widthAnchor.constraint(equalTo: femaleButton.widthAnchor, multiplier: 1, constant: .zero),
          
            locationLabel.topAnchor.constraint(equalTo: maleButton.bottomAnchor, constant: Constants.Spacing.topStandartSpacing),
            locationLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.Spacing.leadingStandartSpacing),
            
            locationTextView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: Constants.Spacing.topStandartSpacing.half),
            locationTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.Spacing.leadingStandartSpacing),
            locationTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constants.Spacing.trailingStandartSpacing.negative),
            locationTextView.heightAnchor.constraint(equalToConstant: Constants.Size.locationTextFieldHeight),
            
            saveButton.topAnchor.constraint(equalTo: locationTextView.bottomAnchor, constant: Constants.Spacing.saveButtonTopSpacing),
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.Spacing.leadingStandartSpacing),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constants.Spacing.trailingStandartSpacing.negative),
            saveButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: Constants.Spacing.saveButtonBottomSpacing.negative),
            saveButton.heightAnchor.constraint(equalToConstant: Constants.Size.saveButtonHeight),
        ])
    }
}

private extension ProfileSettingsVC {
    enum Constants {
        enum Spacing {
            static let topStandartSpacing: CGFloat = 16
            static let leadingStandartSpacing: CGFloat = 24
            static let trailingStandartSpacing: CGFloat = 24
            static let topSpacingForBackButton: CGFloat = 26
            static let topSpacingForTitle: CGFloat = 37
            static let topSpacingForScrollView: CGFloat = 37
            static let leadingSpacingForEditAvatar: CGFloat = 28
            static let spaceBetweenGenderButtons: CGFloat = 16
            static let saveButtonTopSpacing: CGFloat = 64
            static let saveButtonBottomSpacing: CGFloat = 34
        }
        enum Size {
            static let avatarSize: CGFloat = 100
            static let avatarEditSize: CGFloat = 32
            static let locationTextFieldHeight: CGFloat = 132
            static let saveButtonHeight: CGFloat = 56
            static let standartHeight: CGFloat = 52
        }
    }
}

extension ProfileSettingsVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Lorem Ipsum is simply dummy text of the printing and typesetting industry." {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
            textView.textColor = .lightGray
        }
    }
}

private extension ProfileSettingsVC {
    
    func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .gray
        label.font = label.font.withSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func makeTextField(withPlaceholder text: String) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.layer.borderWidth = 1.0
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 24
        textField.layer.borderColor = #colorLiteral(red: 0.3179999888, green: 0.3059999943, blue: 0.7139999866, alpha: 1)
        textField.placeholder = text
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    func makeTextFieldWithCalendar(withPlaceholder text: String) -> UITextField {
        let textField = makeTextField(withPlaceholder: text)
        
        let calendarButton = UIButton(type: .system)
        calendarButton.setImage(#imageLiteral(resourceName: "calendar 1.pdf"), for: .normal)
        calendarButton.tintColor = #colorLiteral(red: 0.3179999888, green: 0.3059999943, blue: 0.7139999866, alpha: 1)
        calendarButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15.5, bottom: 0, right: 0)
        calendarButton.translatesAutoresizingMaskIntoConstraints = true
        textField.rightView = calendarButton
        textField.rightViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        textField.inputView = datePicker
        
        let toolBar = UIToolbar().toolBarPicker(#selector(doneButtonPressed))
        textField.inputAccessoryView = toolBar

        return textField
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        dateOfBirthTextField.text = dateFormatter.string(from:  sender.date)
    }
    
    @objc func doneButtonPressed() {
        dateOfBirthTextField.resignFirstResponder()
    }
}

private extension UIToolbar {
    func toolBarPicker(_ select: Selector) -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.barTintColor = #colorLiteral(red: 0.3176470588, green: 0.3058823529, blue: 0.7137254902, alpha: 1)
        toolBar.tintColor = .white
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: select)
        toolBar.setItems([doneButton], animated: false)
        
        return toolBar
    }
}
extension ProfileSettingsVC: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.avatarImageView.image = image
        avatarImageView.layer.cornerRadius  = avatarImageView.frame.size.width / 2
        avatarImageView.clipsToBounds = true
    }
}
