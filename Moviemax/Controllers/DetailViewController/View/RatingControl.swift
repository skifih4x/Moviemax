//
//  RatingControl.swift
//  Moviemax
//
//  Created by Андрей Фроленков on 6.04.23.
//

import Foundation
import UIKit

class RatingControl: UIStackView {
    
    var ratingButtons = [UIButton]()
    
    var rating = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        spacing = 8
        
        
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Buttons for Rating
    private func setupButtons() {
        
        // load button image
        let filledStar = UIImage(named: "star-4")
        let emptyStar = UIImage(named: "star-3")
        let highlighted = UIImage(named: "star-2")
        
        for _ in 1...5 {
            
            let button = UIButton()
            button.addTarget(nil, action: #selector(DetailViewController.raitingButtonPressed), for: .touchUpInside)
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlighted, for: .highlighted)
            button.setImage(highlighted, for: [.highlighted, .selected])
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 20),
                button.widthAnchor.constraint(equalToConstant: 20),
            ])
            addArrangedSubview(button)
            
            ratingButtons.append(button)
        }
        
    }
    
    // MARK: - Update Button Selection State
    func updateButtonSelectionState() {
        
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
}
