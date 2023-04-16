//
//  OnboardingViewController.swift
//  Moviemax
//
//  Created by Aleksey Kosov on 10.04.2023.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    let authManager = AuthManager()

    private lazy var pages: [OnboardingPageContentViewController] = {
        let page1 = OnboardingPageContentViewController(title: "Discover Movies & TV Shows",
                                                        description: "Browse a vast library of films and series from various genres and languages.",
                                                        pageIndex: 0)

        let page2 = OnboardingPageContentViewController(title: "Create Your Watchlist",
                                                        description: "Save your favorites and get personalized recommendations to find your next favorite show.",
                                                        pageIndex: 1)

        let page3 = OnboardingPageContentViewController(title: "Stay Updated",
                                                        description: "Receive notifications for new episodes, premieres, and recommendations tailored just for you.",
                                                        pageIndex: 2)


        // Set the delegate for each page
        page1.delegate = self
        page2.delegate = self
        page3.delegate = self

        return [page1, page2, page3]
    }()

    lazy var womenImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "women")
        return imageView
    }()

    lazy var floatingBubbles: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "bubbles")
        return imageView
    }()

    lazy var pageViewController: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageVC.view.backgroundColor = .systemBackground
        pageVC.view.layer.cornerRadius = 16
        pageVC.view.clipsToBounds = true
        return pageVC
    }()

    private lazy var pageControl: CustomPageControl = {
           let control = CustomPageControl()
           control.translatesAutoresizingMaskIntoConstraints = false
           control.numberOfPages = 3
           control.currentPage = 0

        control.transform = CGAffineTransform.init(scaleX: scale, y: scale)


        control.preferredCurrentPageIndicatorImage = UIImage(named: "Dot")?.applyingSymbolConfiguration(.init(scale: .small))
           control.pageIndicatorTintColor = .gray
           control.currentPageIndicatorTintColor = UIColor(named: "purple")
        control.setNeedsDisplay()
           return control
       }()
    let scale = 1.5
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPageViewController()

        for dot in pageControl.subviews{
            dot.transform = CGAffineTransform.init(scaleX: 1/scale, y: 1/scale)
        }
    }




    private func setupUI() {
        view.backgroundColor = UIColor(named: "purple")
        view.addSubview(floatingBubbles)
        view.addSubview(womenImageView)

        NSLayoutConstraint.activate([

            floatingBubbles.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            floatingBubbles.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            floatingBubbles.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            floatingBubbles.bottomAnchor.constraint(equalTo: womenImageView.centerYAnchor, constant: 50),

            womenImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            womenImageView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            womenImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            womenImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // Add the pageViewController as a child view controller
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.centerYAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])

        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: pageViewController.view.topAnchor, constant: 0),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupPageViewController() {
        let pages = self.pages
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }

    private func presentDestinationViewController() {
        let destinationViewController = MainTabBarController()
        let loginVC = LoginViewController()
        
        authManager.registerAuthStateHandler { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success( _ ):
                DispatchQueue.main.async {
                    destinationViewController.modalPresentationStyle = .fullScreen
                    self.present(destinationViewController, animated: true, completion: nil)
                    UserDefaults.standard.set(true, forKey: "isOnboarded")
                }
                
            case .failure( _ ):
                DispatchQueue.main.async {
                    loginVC.modalPresentationStyle = .fullScreen
                    self.present(loginVC, animated: true, completion: nil)
                    UserDefaults.standard.set(true, forKey: "isOnboarded")
                }
                
            }
        }
        
//        destinationViewController.modalPresentationStyle = .fullScreen
//        present(destinationViewController, animated: true, completion: nil)
//        UserDefaults.standard.set(true, forKey: "isOnboarded")
    }
}

// Implement UIPageViewControllerDataSource and UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 3
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? OnboardingPageContentViewController,
              let index = (pages.firstIndex { $0.pageIndex == viewController.pageIndex }) else {
            return nil
        }

        let previousIndex = index - 1
        return previousIndex >= 0 ? pages[previousIndex] : nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? OnboardingPageContentViewController,
              let index = (pages.firstIndex { $0.pageIndex == viewController.pageIndex }) else {
            return nil
        }

        let nextIndex = index + 1
        return nextIndex < pages.count ? pages[nextIndex] : nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentVC = pageViewController.viewControllers?.first as? OnboardingPageContentViewController {
            pageControl.currentPage = currentVC.pageIndex
        }
    }
}

extension OnboardingViewController: OnboardingPageContentViewControllerDelegate {
    func continueButtonTapped(on viewController: OnboardingPageContentViewController) {
        if let index = pages.firstIndex(where: { $0.pageIndex == viewController.pageIndex }),
           index + 1 < pages.count {
            pageViewController.setViewControllers([pages[index + 1]], direction: .forward, animated: true, completion: nil)
            pageControl.currentPage = index + 1
        } else {
            presentDestinationViewController()
        }
    }
}
