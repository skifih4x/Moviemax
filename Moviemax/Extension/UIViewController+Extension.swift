//
//  UIViewController+Extension.swift
//  Movve
//
//  Created by Aleksey Kosov on 04.04.2023.
//

import UIKit

extension UIViewController {

    func presentAlert(title: String = "Something went wrong",
                      message: String = "We were unable to complete your task at this time. Please try again.",
                      buttonTitle: String = "OK",
                      completion: @escaping ()->()) {

        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            DispatchQueue.main.async {
                completion()
            }
        }
        alertVC.addAction(alertAction)

        DispatchQueue.main.async {
            self.present(alertVC, animated: true)
        }
    }

    func presentDefaultError(errorText: String = "We were unable to complete your task at this time. Please try again.") {

        let alertVC = UIAlertController(title: "Something went wrong",
                                        message: errorText,
                                        preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alertVC.addAction(action)
        DispatchQueue.main.async {
            self.present(alertVC, animated: true)
        }
    }
}
