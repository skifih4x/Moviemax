//
//  StackView + Extension.swift
//  Moviemax
//
//  Created by Андрей Фроленков on 4.04.23.
//

import Foundation
import UIKit

extension UIStackView {
    
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        alignment = .center
    }
    

}

extension CGFloat {
    var negative: CGFloat { self * -1.0 }
    var half: CGFloat { self / 2 }
}
