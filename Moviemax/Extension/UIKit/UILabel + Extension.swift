//
//  UILabel + Extension.swift
//  Moviemax
//
//  Created by Андрей Фроленков on 4.04.23.
//

import Foundation
import UIKit

extension UILabel {
    
    convenience init(text :String, font: UIFont? = .systemFont(ofSize: 20), textColor: UIColor? = .white) {
        self.init()
        
        self.textColor = textColor
        self.font = font
        self.text = text
    }
}
