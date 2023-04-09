//
//  DetailViewController.swift
//  Moviemax
//
//  Created by Андрей Фроленков on 6.04.23.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    let array = ["mfdvmfmvfmerferferferfer", "dfjvmkfdffdf", "sdjjsj"]
    var indexCell = 0
    
    var buttonTapped = false
    
    // MARK: - Custom RatingControl
    let raitingStack = RatingControl(frame: .zero)
    
    // MARK: - CollectionView
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - UI Elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
//        scrollView.frame = view.bounds
        scrollView.isUserInteractionEnabled = true
        scrollView.contentSize = contentSize
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        view.frame.size = contentSize
        return view
    }()
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    let imageFilm = UIImageView(image: UIImage(named: "image1"), contentMode: .scaleAspectFill)
    let nameFilm = UILabel(text: "Avatar", font: UIFont.systemFont(ofSize: 24, weight: .bold), textColor: UIColor(named: K.Colors.titleColor))
    
    let dataImage = UIImageView(image: UIImage(named: "data"), contentMode: .scaleAspectFill)
    let datalabel = UILabel(text: "17 Sep 21", font: UIFont.systemFont(ofSize: 12))
    
    let timeImage = UIImageView(image: UIImage(named: "clock"), contentMode: .scaleAspectFill)
    let timelabel = UILabel(text: "148 Minutes", font: UIFont.systemFont(ofSize: 12))
    
    let genreImage = UIImageView(image: UIImage(named: "genre"), contentMode: .scaleAspectFill)
    let genrelabel = UILabel(text: "Action", font: UIFont.systemFont(ofSize: 12))
    
    let storyLineLabel = UILabel(text: "Story Line", font: UIFont.systemFont(ofSize: 16, weight: .bold), textColor: UIColor(named: K.Colors.titleColor))
    
    let castAndCrewLabel = UILabel(text: "Cast And Crew", font: UIFont.systemFont(ofSize: 16, weight: .bold), textColor: UIColor(named: K.Colors.titleColor))
   
    let watchNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Watch now", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3925074935, green: 0.3996650577, blue: 0.7650645971, alpha: 1)
        button.layer.cornerRadius = 20
        
        return button
    }()
    

    let textView = ExpandableLabel(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book", font: UIFont.systemFont(ofSize: 18), textColor: UIColor(named: K.Colors.titleColor))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: K.Colors.background)
        
        collectionView.dataSource = self
        collectionView.delegate   = self
        
        watchNowButton.addTarget(self, action: #selector(watchNowButtonPressed), for: .touchUpInside)
        self.collectionView.register(CastAndCrewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        
        configureBarButtonItem()
        settingsNavigationBar()
        setupConstraints()
        watchNowButton.addPulsationAnimation()

    }
    
    @objc func watchNowButtonPressed() {
        print("Hello")
    }
    
    // MARK: - Action LeftBarButtonItem
    @objc private func buttonLeftPressed() {
        self.navigationController?.popToRootViewController(animated: true)
        print("buttonLeftPressed")
    }
    
    // MARK: - Action RightBarButtonItem
    @objc func buttonRightPressed(_ sender: UIBarButtonItem) {
        buttonTapped = !buttonTapped
        sender.image = buttonTapped ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        sender.tintColor = buttonTapped ? .red : .gray
    }
    
    // MARK: - Action Raiting Button
    @objc func raitingButtonPressed(sender: UIButton) {
        
        guard let index = raitingStack.ratingButtons.firstIndex(of: sender) else { return }
        
        let selectedRating = index + 1
        print(selectedRating)
        
        if selectedRating == raitingStack.rating {
            raitingStack.rating = 0
        } else {
            raitingStack.rating = selectedRating
        }
    }

}

// MARK: - Configure BarButtonItem
extension DetailViewController {
    
    private func setupConstraints() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        nameFilm.translatesAutoresizingMaskIntoConstraints = false
        raitingStack.translatesAutoresizingMaskIntoConstraints = false
        storyLineLabel.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        castAndCrewLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        watchNowButton.translatesAutoresizingMaskIntoConstraints = false
        
        let dataStack = UIStackView(arrangedSubviews: [dataImage, datalabel], axis: .horizontal, spacing: 5)
        
        NSLayoutConstraint.activate([
            dataImage.heightAnchor.constraint(equalToConstant: 12),
            dataImage.widthAnchor.constraint(equalToConstant: 12),
        ])
        let timeStack = UIStackView(arrangedSubviews: [timeImage, timelabel], axis: .horizontal, spacing: 5)
        NSLayoutConstraint.activate([
            timeImage.heightAnchor.constraint(equalToConstant: 12),
            timeImage.widthAnchor.constraint(equalToConstant: 12),
        ])
        let genreStack = UIStackView(arrangedSubviews: [genreImage, genrelabel], axis: .horizontal, spacing: 5)
        NSLayoutConstraint.activate([
            genreImage.heightAnchor.constraint(equalToConstant: 12),
            genreImage.widthAnchor.constraint(equalToConstant: 12),
        ])
        
        let mainStack = UIStackView(arrangedSubviews: [dataStack, timeStack, genreStack], axis: .horizontal, spacing: 24)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.distribution = .fillProportionally
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageFilm)
        contentView.addSubview(nameFilm)
        contentView.addSubview(mainStack)
        contentView.addSubview(raitingStack)
        contentView.addSubview(storyLineLabel)
        contentView.addSubview(textView)
        contentView.addSubview(castAndCrewLabel)
        contentView.addSubview(collectionView)
        view.addSubview(watchNowButton)
        
        // MARK: - Constraint imageFilm
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: watchNowButton.topAnchor, constant: 20)
        ])
        
        // MARK: - Constraint imageFilm
        NSLayoutConstraint.activate([
            imageFilm.heightAnchor.constraint(equalToConstant: 300),
            imageFilm.widthAnchor.constraint(equalToConstant: 225),
            imageFilm.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageFilm.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 43)
        ])
        // MARK: - Constraint nameFilm
        NSLayoutConstraint.activate([
            nameFilm.topAnchor.constraint(equalTo: imageFilm.bottomAnchor, constant: 24),
            nameFilm.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
        
        // MARK: - mainstack
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: nameFilm.bottomAnchor, constant: 16),
            mainStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
        
        // MARK: - RatingStack
        NSLayoutConstraint.activate([
            raitingStack.topAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: 16),
            raitingStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
        // MARK: - StoryLine label
        NSLayoutConstraint.activate([
            storyLineLabel.topAnchor.constraint(equalTo: raitingStack.bottomAnchor, constant: 32),
            storyLineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
        ])
        
        // MARK: - StoryLine label
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: storyLineLabel.bottomAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
        ])
        
        // MARK: - castAndCrewLabel
        NSLayoutConstraint.activate([
            castAndCrewLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 40),
            castAndCrewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            castAndCrewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
        ])
        
        // MARK: - CollectionView
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: castAndCrewLabel.bottomAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 100)
        ])

        // MARK: - StoryLine label
        NSLayoutConstraint.activate([
//            watchNowButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 70),
            watchNowButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            watchNowButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            watchNowButton.heightAnchor.constraint(equalToConstant: 50),
            watchNowButton.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = array[indexPath.item]
        let width = text.count * 10 + 40
        return CGSize(width: width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20,
                            left: 20,
                            bottom: 20,
                            right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? CastAndCrewCell else { return UICollectionViewCell()}
        
        let width = array[indexPath.item]
        cell.titleLabel.text = width
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexCell = indexPath.item
        
        DispatchQueue.main.async {
            collectionView.reloadData()
        }
        
    }
}

// MARK: - Configure BarButtonItem
extension DetailViewController {
    
    private func configureBarButtonItem() {
        let rightButton: UIBarButtonItem = {
            let rightButton = UIBarButtonItem()
            rightButton.image = UIImage(systemName: "heart")
            rightButton.tintColor = UIColor(named: K.Colors.rightBarButtonColor)
            rightButton.target = self
            rightButton.action = #selector(buttonRightPressed)
            return rightButton
        }()
        
        let leftButton: UIBarButtonItem = {
            let leftButton = UIBarButtonItem()
            leftButton.image = UIImage(named: "Arrow Back")
            leftButton.tintColor = UIColor(named: K.Colors.leftBarButtonColor)
            leftButton.target = self
            leftButton.action = #selector(buttonLeftPressed)
            return leftButton
        }()
        
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
    }
}

// MARK: - Settings NavigationBar
extension DetailViewController {
    
    private func settingsNavigationBar() {
        
        title = "Movie Detail"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: K.Colors.background)
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: K.Colors.titleColor) ?? .white,
                                          .font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        appearance.shadowColor = .clear
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        //        navigationController?.navigationBar.prefersLargeTitles = true
        
        definesPresentationContext = true
    }
}
