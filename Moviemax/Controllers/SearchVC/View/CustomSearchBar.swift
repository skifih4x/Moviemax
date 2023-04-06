//
//  CustomSearchBar.swift
//  Moviemax
//
//  Created by Андрей Фроленков on 4.04.23.
//

import Foundation
import UIKit

class CustomSearchBar: UISearchBar {
    
    public var textField: UITextField? {
        if #available(iOS 13, *) {
            return searchTextField
        }
        let subViews = subviews.flatMap { $0.subviews }
        guard let textfield = (subViews.filter { $0 is UITextField }).first as? UITextField else { return nil }
        return textfield
    }
    
    public var activityIndicator: UIActivityIndicatorView? {
        return textField?.leftView?.subviews.compactMap { $0 as? UIActivityIndicatorView }.first
    }
    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            if newValue {
                if activityIndicator == nil {
                    let newActivityIndicator = UIActivityIndicatorView(style: .medium)
                    newActivityIndicator.color = UIColor.gray
                    newActivityIndicator.startAnimating()
                    newActivityIndicator.backgroundColor = textField?.backgroundColor ?? UIColor.white
                    textField?.leftView?.addSubview(newActivityIndicator)
                    let leftViewsize = textField?.leftView?.frame.size ?? CGSize.zero
                    newActivityIndicator.center = CGPoint(x: leftViewsize.width / 2, y: leftViewsize.height / 2)
                }
            } else {
                activityIndicator?.removeFromSuperview()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        searchBarStyle = .minimal
        textField?.placeholder = "Введите название"
        textField?.textColor = UIColor(named: K.Colors.titleColor)
        textField?.backgroundColor = UIColor(named: K.Colors.background)
        textField?.borderStyle = .none
        textField?.layer.cornerRadius = 20
        textField?.layer.borderWidth = 1
        textField?.layer.borderColor = #colorLiteral(red: 0.3925074935, green: 0.3996650577, blue: 0.7650645971, alpha: 1).cgColor
        textField?.font = UIFont.systemFont(ofSize: 16)
        textField?.leftView?.tintColor = #colorLiteral(red: 0.4705882353, green: 0.5098039216, blue: 0.5411764706, alpha: 1)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changePlaceholderColor(_ color: UIColor) {
        guard let UISearchBarTextFieldLabel: AnyClass = NSClassFromString ( "UISearchBarTextFieldLabel"),
              let field = textField else { return }
        
        for subview in field.subviews where subview.isKind(of: UISearchBarTextFieldLabel) {
            (subview as! UILabel).textColor = color
        }
    }
    
    func setRightImage (_ image: UIImage) {
        showsBookmarkButton = true
        
        if let btn = textField?.rightView as? UIButton {
            btn.setImage(image, for: .normal)
            btn.setImage(image, for: .highlighted)
        }
    }
    
}
