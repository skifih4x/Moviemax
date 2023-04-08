//
//  CustomGenderButton.swift
//  Moviemax
//
//  Created by Даниил Петров on 08.04.2023.
//

import UIKit

//protocol CustomCellDelegate: AnyObject {
//    func TextFieldDidEndEditing(textField: UITextField, text: String)
//}

final class GenderCustomButton: UIButton {
    
    enum ButtonType {
        case male
        case female
    }
    
    var actionHandler: (() -> Void)?
    
    var isTapped: Bool = false
    
    let type: ButtonType
    
    lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var genderStateView: UIImageView = {
        let view = UIImageView()
        view.tintColor = isSelected ? .systemBlue : .systemGray
        view.image = isSelected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            isTapped = isSelected
            genderStateView.tintColor = isSelected ? #colorLiteral(red: 0.3179999888, green: 0.3059999943, blue: 0.7139999866, alpha: 1) : .systemGray
            genderStateView.image = isSelected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
            
            if isSelected, let previousButton = superview?.subviews.compactMap({ $0 as? GenderCustomButton }).first(where: { $0 != self && $0.isSelected }) {
                previousButton.isSelected = false
            }
        }
    }
    
    init(type: ButtonType, action: (() -> Void)?) {
        self.type = type
        super.init(frame: .zero)
        setupView()
        setButtonStyle(type)
        self.actionHandler = action
        self.layer.cornerRadius = 24
        self.layer.borderColor = #colorLiteral(red: 0.3179999888, green: 0.3059999943, blue: 0.7139999866, alpha: 1)
        self.layer.borderWidth = 1.0
        self.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        actionHandler?()
        switch self {
        case let button where button.type == .male:
            button.isSelected = true
            superview?.subviews.compactMap({ $0 as? GenderCustomButton })
                .filter { $0 != self && $0.type == .female }
                .forEach { $0.isSelected = false }
        case let button where button.type == .female:
            button.isSelected = true
            superview?.subviews.compactMap({ $0 as? GenderCustomButton })
                .filter { $0 != self && $0.type == .male }
                .forEach { $0.isSelected = false }
        default:
            break
        }
    }
    
    private func setButtonStyle(_ type: ButtonType) {
        switch type {
        case .male:
            genderLabel.text = "Male"
        case .female:
            genderLabel.text = "Female"
        }
    }
    
    private func setupView() {
        addSubview(genderLabel)
        addSubview(genderStateView)
        
        NSLayoutConstraint.activate([
            genderStateView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            genderStateView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            genderStateView.widthAnchor.constraint(equalToConstant: 24),
            genderStateView.heightAnchor.constraint(equalToConstant: 24),
            
            genderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            genderLabel.leadingAnchor.constraint(equalTo: genderStateView.trailingAnchor, constant: 16),
            self.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
