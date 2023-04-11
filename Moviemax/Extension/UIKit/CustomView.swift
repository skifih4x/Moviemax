//
//  CustomView.swift
//  Moviemax
//
//  Created by Sergey on 11.04.2023.
//

import Foundation
import UIKit

// MARK: - CustomView
class CustomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        layoutViews()
    }
    
    func setupViews() {
        backgroundColor = UIColor.systemBackground
    }
    
    func layoutViews() {
        
    }
}

