//
//  FilterButton.swift
//  Moviemax
//
//  Created by Aleksey Kosov on 11.04.2023.
//

import UIKit

final class FilterButton: UIButton {

    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .purple : .white
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
