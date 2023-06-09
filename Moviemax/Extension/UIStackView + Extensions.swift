//
//  UIStackView + Extensions.swift
//  Moviemax
//
//  Created by Ildar Garifullin on 04/04/2023.
//

import UIKit

extension UIStackView {
    convenience init(customArrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init(arrangedSubviews: customArrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
