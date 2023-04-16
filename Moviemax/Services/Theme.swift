//
//  Theme.swift
//  Moviemax
//
//  Created by Sergey on 15.04.2023.
//

import Foundation
import UIKit

enum Theme: String {
    case light, dark, system

    // Utility var to pass directly to window.overrideUserInterfaceStyle
    var uiInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return .unspecified
        }
    }
}
