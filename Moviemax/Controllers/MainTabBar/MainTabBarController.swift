//
//  MainTabBarController.swift
//  Moviemax
//
//  Created by Артем Орлов on 02.04.2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    

    private let middleButtonDiameter: CGFloat = 42

    private lazy var middleButton: UIButton = {
        let middleButton = UIButton()
        middleButton.layer.cornerRadius = middleButtonDiameter / 2
        middleButton.backgroundColor = .lightGray
        middleButton.translatesAutoresizingMaskIntoConstraints = false
        middleButton.addTarget(self, action: #selector(didPressMiddleButton), for: .touchUpInside)
        return middleButton
    }()
    
    private lazy var heartImageView: UIImageView = {
        let heartImageView = UIImageView()
        heartImageView.image = UIImage(systemName: "house.fill")
        heartImageView.tintColor = .white
        heartImageView.translatesAutoresizingMaskIntoConstraints = false
        return heartImageView
    }()
    
    var customTabBar = CustomTabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setValue(customTabBar, forKey: "tabBar")
      
        tabBar.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.9960784314, blue: 0.9960784314, alpha: 1)
        tabBar.tintColor = #colorLiteral(red: 0.3176470588, green: 0.3058823529, blue: 0.7137254902, alpha: 1)
        
        let searchViewController      = SearchViewController()
        let videoViewController       = VideoViewController()
        let homeViewController        = HomeViewController()
        let favoritesViewController   = FavoritesViewController()
        let profileViewController     = ProfileViewController()
//        let profileViewController     = LoginViewController()
        
        searchViewController.title    = "Search"
        videoViewController.title     = "Recent watch"
        homeViewController.title      = "Home"
        favoritesViewController.title = "Favorites"
//        profileViewController.title   = "Profile"
        profileViewController.title   = ""
        
        let boldConfig                = UIImage.SymbolConfiguration(weight: .medium)
        let searchImage               = UIImage(systemName: "magnifyingglass", withConfiguration: boldConfig)!
        let videoImage                = UIImage(systemName: "play.circle")!
        let homeImage                 = UIImage(systemName: "play.circle")!
        let favoritesImage            = UIImage(systemName: "heart.fill")!
        let profileImage              = UIImage(systemName: "person.crop.circle")!
       
        
        
        viewControllers = [generateNavigationController(rootViewController: searchViewController, image: searchImage),
                           generateNavigationController(rootViewController: videoViewController, image: videoImage),
                           generateNavigationController(rootViewController: homeViewController, image: homeImage),
                           generateNavigationController(rootViewController: favoritesViewController, image: favoritesImage),
                           generateNavigationController(rootViewController: profileViewController, image: profileImage)
        ]
        
        makeUI()
    }
    
    @objc private func didPressMiddleButton() {
        selectedIndex = 2
        middleButton.backgroundColor = #colorLiteral(red: 0.3176470588, green: 0.3058823529, blue: 0.7137254902, alpha: 1)
    }
    
    private func makeUI() {
        // 1
        tabBar.addSubview(middleButton)
        middleButton.addSubview(heartImageView)

        // 2
        NSLayoutConstraint.activate([
            // 2.1
            middleButton.heightAnchor.constraint(equalToConstant: middleButtonDiameter),
            middleButton.widthAnchor.constraint(equalToConstant: middleButtonDiameter),
            // 2.2
            middleButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            middleButton.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -10)
        ])

        // 3
        NSLayoutConstraint.activate([
            // 3.1
            heartImageView.heightAnchor.constraint(equalToConstant: 25),
            heartImageView.widthAnchor.constraint(equalToConstant: 30),
            // 3.2
            heartImageView.centerXAnchor.constraint(equalTo: middleButton.centerXAnchor),
            heartImageView.centerYAnchor.constraint(equalTo: middleButton.centerYAnchor)
        ])
    }
    
    private func generateNavigationController(rootViewController: UIViewController, image: UIImage) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }

}

// MARK: - UITabBarControllerDelegate
extension MainTabBarController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let selectedIndex = self.tabBar.items?.firstIndex(of: item) // 1
        if selectedIndex == 2 { // 2
            middleButton.backgroundColor = #colorLiteral(red: 0.3176470588, green: 0.3058823529, blue: 0.7137254902, alpha: 1) // 3
        } else {
            middleButton.backgroundColor = .lightGray // 4
        }
    }
    
}


