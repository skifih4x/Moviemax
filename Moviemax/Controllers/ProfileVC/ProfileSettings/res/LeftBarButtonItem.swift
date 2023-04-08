//
//  LeftBarButtonItem.swift
//  Moviemax
//
//  Created by Даниил Петров on 06.04.2023.
//

import Foundation
import UIKit



import UIKit


class CustomBarButtonItem: UIBarButtonItem {
    
    init(target: Any?, action: Selector?) {
        let button = UIButton(type: .system)
        let image = UIImage(named: "BackBarButton")?.withRenderingMode(.alwaysOriginal)
        button.addTarget(target, action: action!, for: .touchUpInside)
        button.setBackgroundImage(image, for: .normal)
        
        button.contentMode = .scaleAspectFit
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        
        super.init()
        customView = button
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
