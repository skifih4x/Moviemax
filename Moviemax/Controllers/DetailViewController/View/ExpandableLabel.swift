//
//  RedMoreTextLabel.swift
//  Moviemax
//
//  Created by Андрей Фроленков on 6.04.23.
//

import Foundation
import UIKit

class ExpandableLabel: UILabel {
    
    var isExpaded = false
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let buttonAray =  self.superview?.subviews.filter({ (subViewObj) -> Bool in
            return subViewObj.tag ==  9090
        })
        
        if buttonAray?.isEmpty == true {
            self.addReadMoreButton()
        }
    }
    
    //Add readmore button in the label.
    func addReadMoreButton() {
        
        let theNumberOfLines = numberOfLinesInLabel(yourString: self.text ?? "", labelWidth: self.frame.width, labelHeight: self.frame.height, font: self.font)
        
        let height = self.frame.height
        self.numberOfLines =  self.isExpaded ? 0 : 2
        
        if theNumberOfLines > 2{
            
            self.numberOfLines = 2
            
            let button = UIButton(frame: CGRect(x: 0, y: height+15, width: 70, height: 15))
            button.tag = 9090
            button.frame = self.frame
            button.frame.origin.y =  self.frame.origin.y  +  self.frame.size.height + 25
            button.setTitle("Read more...", for: .normal)
            button.titleLabel?.font = button.titleLabel?.font.withSize(12)
            button.backgroundColor = .clear
            let color = #colorLiteral(red: 0.3925074935, green: 0.3996650577, blue: 0.7650645971, alpha: 1)
            button.setTitleColor(color, for: .normal)
            button.addTarget(self, action: #selector(ExpandableLabel.buttonTapped(sender:)), for: .touchUpInside)
            self.superview?.addSubview(button)
            self.superview?.bringSubviewToFront(button)
            button.setTitle("Read less..", for: .selected)
            button.isSelected = self.isExpaded
            button.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                button.bottomAnchor.constraint(equalTo:  self.bottomAnchor, constant: +20)
                ])
        }else{
            
            self.numberOfLines = 2
        }
    }
    
    //Calculating the number of lines. -> Int
    func numberOfLinesInLabel(yourString: String, labelWidth: CGFloat, labelHeight: CGFloat, font: UIFont) -> Int {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = labelHeight
        paragraphStyle.maximumLineHeight = labelHeight
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let attributes: [NSAttributedString.Key: AnyObject] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font, NSAttributedString.Key(rawValue: NSAttributedString.Key.paragraphStyle.rawValue): paragraphStyle]
        
        let constrain = CGSize(width: labelWidth, height: CGFloat(Float.infinity))
        
        let size = yourString.size(withAttributes: attributes)
        
        let stringWidth = size.width
        
        let numberOfLines = ceil(Double(stringWidth/constrain.width))
        
        return Int(numberOfLines)
    }
    
    //ReadMore Button Action
    @objc func buttonTapped(sender : UIButton) {
        
        
        
        self.isExpaded = !isExpaded
        sender.isSelected =   self.isExpaded
        
        self.numberOfLines =  sender.isSelected ? 0 : 2
        
        self.layoutIfNeeded()
        
        var viewObj :UIView?  = self
        var cellObj :UITableViewCell?
        while viewObj?.superview != nil  {
          
           if let cell = viewObj as? UITableViewCell  {
                
              cellObj = cell
            }
            
            if let tableView = (viewObj as? UITableView)  {
               
                if let indexPath = tableView.indexPath(for: cellObj ?? UITableViewCell()){
                                        
                    tableView.beginUpdates()
                    print(indexPath)
                    tableView.endUpdates()
                    
                }
                return
            }

            viewObj = viewObj?.superview
        }
 
        
    }
    
}
