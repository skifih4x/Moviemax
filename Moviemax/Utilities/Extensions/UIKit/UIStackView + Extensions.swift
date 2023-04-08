//
//  UIStackView + Extensions.swift
//  Moviemax
//
//  Created by Ildar Garifullin on 04/04/2023.
//

import UIKit

extension UIStackView {
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension CGFloat {
    var negative: CGFloat { self * -1.0 }
    var half: CGFloat { self / 2 }
}
