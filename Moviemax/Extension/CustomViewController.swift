//
//  CustomViewController.swift
//  Moviemax
//
//  Created by Sergey on 05.04.2023.
//

import Foundation
import UIKit

// MARK: - CustomViewController
class CustomViewController<V: CustomView>: UIViewController {
    
    override func loadView() {
        view = V()
    }
    
    
    var customView: V {
        view as! V
    }
}
