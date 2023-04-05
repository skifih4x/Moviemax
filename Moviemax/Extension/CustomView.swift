//
//  CustomView.swift
//  Moviemax
//
//  Created by Sergey on 05.04.2023.
//

import Foundation
import UIKit

// MARK: - CustomView
class CustomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setViews()
        layoutViews()
    }
    
    func setViews() {
        backgroundColor = UIColor.systemBackground
    }
    
    func layoutViews() {
        
    }
}
