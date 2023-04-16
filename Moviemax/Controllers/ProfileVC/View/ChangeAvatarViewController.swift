//
//  ChangeAvatarViewController.swift
//  Moviemax
//
//  Created by Даниил Петров on 10.04.2023.
//
/*
import UIKit

class ChangeAvatarViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        

        let titleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: view.frame.width - 20, height: 30))
        titleLabel.text = "Change your picture"
        titleLabel.textAlignment = .center
        //        titleLabel.textAlignment = .left
        view.addSubview(titleLabel)
        
        //MARK: Ширина кнопки захардкожена
        // Кнопки
        let button1 = createButton(title: "Take a photo", image: UIImage(named: "TakeAPhoto")?.withRenderingMode(.alwaysOriginal))
        button1.frame = CGRect(x: 20, y: 70, width: view.frame.width - 130, height: 50)
        view.addSubview(button1)
        
        let button2 = createButton(title: "Choose from your file", image: UIImage(named: "ChooseFromYourFile")?.withRenderingMode(.alwaysOriginal))
        button2.frame = CGRect(x: 20, y: button1.frame.maxY + 20, width: view.frame.width - 130, height: 50)
        view.addSubview(button2)
        
        let button3 = createButton(title: "Delete photo", image: UIImage(named: "DeletePhoto")?.withRenderingMode(.alwaysOriginal))
        button3.frame = CGRect(x: 20, y: button2.frame.maxY + 20, width: view.frame.width - 130, height: 50)
        button3.titleLabel?.tintColor = .systemRed
        view.addSubview(button3)
    }
    
    func createButton(title: String, image: UIImage?) -> UIButton {
        let button = UIButton(type: .system)

        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setImage(image, for: .normal)
        
        button.imageView?.frame = CGRect(x: 0, y: 0, width: 17, height: 17)
        
        button.tintColor = .black
        button.backgroundColor = UIColor.systemGray6
        button.layer.cornerRadius = 5
        
        button.contentHorizontalAlignment = .left
        
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        print(image?.size as Any)
        return button
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        // Обработка нажатия на кнопку
        switch sender.titleLabel?.text {
        case "Take a photo":
            print("Нажата кнопка 1")
        case "Choose from your file":
            print("Нажата кнопка 2")
        default:
            print("Нажата кнопка 3")
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func showPopup() {


        let popupView = UIView()
        
        popupView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(popupView)
        

        let popupWidth: CGFloat = 300
        let popupHeight: CGFloat = 300
        popupView.frame = CGRect(x: view.frame.midX - popupWidth/2,
                                 y: view.frame.midY - popupHeight/2,
                                 width: popupWidth,
                                 height: popupHeight)
        
        
    }
    
    
}
*/
