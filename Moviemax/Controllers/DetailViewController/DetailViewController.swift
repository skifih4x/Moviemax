//
//  DetailViewController.swift
//  Moviemax
//
//  Created by Андрей Фроленков on 6.04.23.
//

import UIKit
import SafariServices

final class DetailViewController: UIViewController {
    let databaseService: DatabaseService = RealmService.shared
    var add: Bool = false
    var id: Int?
    var detailModel: DetailMultimediaModel?
    var castArray = [Cast]()
    
    var indexCell = 0
    
    var buttonTapped = false
    
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
    
    let imageFilm = CustomImageView(frame: .zero)
    let nameFilm = UILabel(text: "Avatar", font: UIFont.systemFont(ofSize: 24, weight: .bold), textColor: UIColor(named: K.Colors.titleColor))
    
    let dataImage = UIImageView(image: UIImage(named: "calendar"), contentMode: .scaleAspectFill)
    let datalabel = UILabel(text: "17 Sep 21", font: UIFont.systemFont(ofSize: 12), textColor: UIColor(named: K.Colors.labelColor))
    
    let timeImage = UIImageView(image: UIImage(named: "clock"), contentMode: .scaleAspectFill)
    let timelabel = UILabel(text: "148 Minutes", font: UIFont.systemFont(ofSize: 12), textColor: UIColor(named: K.Colors.labelColor))
    
    let genreImage = UIImageView(image: UIImage(named: "genre"), contentMode: .scaleAspectFill)
    let genrelabel = UILabel(text: "Action", font: UIFont.systemFont(ofSize: 12), textColor: UIColor(named: K.Colors.labelColor))
    
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
    
    let manager = MultimediaLoader.shared
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 1, green: 0.7547127604, blue: 0.0322817266, alpha: 1)
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return label
    }()
    
    lazy var starsStackView: UIStackView = {
        var arrangedSubviews = [UIView]()
        (0..<5).forEach { _ in
            let imageView = UIImageView(image: #imageLiteral(resourceName: "star-4"))
            imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
            arrangedSubviews.append(imageView)
        }
        arrangedSubviews.append(UIView())

        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.fetchDetailDataByID(type: .movie, id: id?.description ?? "") { [weak self] detailModel in
            
            DispatchQueue.main.async {
                self?.imageFilm.activityIndicator.startAnimating()
            }
            
            if let detailModel {
                self?.detailModel = detailModel
                self?.setDetailModel(with: detailModel)
                
                self?.manager.fetchCastDataById(id: self?.id?.description ?? "", type: .movie, completion: { castModel in
                    self?.castArray = castModel?.cast ?? []
                    
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                })
                //add to recentWatch
                self?.addToRecentWatch(detailModel)
            }
            
        }
        
        view.backgroundColor = UIColor(named: K.Colors.background)
        
        collectionView.dataSource = self
        collectionView.delegate   = self
        
        watchNowButton.addTarget(self, action: #selector(watchNowButtonPressed), for: .touchUpInside)
        self.collectionView.register(CastAndCrewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        
        configureBarButtonItem()
        settingsNavigationBar()
        setupConstraints()
        watchNowButton.addPulsationAnimation()
        if let id = id {
            let pressed = databaseService.isInFavorites(id)
            navigationItem.rightBarButtonItem?.image = pressed ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            navigationItem.rightBarButtonItem?.tintColor = .red
        }
    }
    //MARK: - Database methods
    private func addToRecentWatch(_ movie: DetailMultimediaModel) {
        let dataModel = MultimediaViewModel(id: movie.id, type: .movie, posterImageLink: movie.posterPath, titleName: movie.title ?? movie.name ?? "", releaseDate: movie.releaseDate ?? "", genre: movie.genres.first?.name, description: movie.overview, rating: movie.voteAverage)
        databaseService.addToRecentWatch(dataModel)
        if !databaseService.isInRecentWatch(movie.id) {
            databaseService.addToRecentWatch(dataModel)
        }
    }
    
    func isFavorite() {
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
        navigationItem.rightBarButtonItem?.tintColor = .red
    }
    
    // MARK: - Set Detail Model
    func setDetailModel(with detailModel: DetailMultimediaModel) {
        
        DispatchQueue.main.async {
            self.nameFilm.text = detailModel.name ?? detailModel.title
            self.datalabel.text = detailModel.releaseDate
            self.genrelabel.text = detailModel.genres.first?.name
            self.textView.text = detailModel.overview
            self.updateStars(rating: detailModel.voteAverage)
            
            if let model = detailModel.runtime {
                self.timelabel.text = "\(model) Minutes"
            }
            
        }
        
        self.manager.fetchImage(from: detailModel.posterPath) { [weak self] image in
            
            DispatchQueue.main.async {
                self?.imageFilm.image = image
                self?.imageFilm.activityIndicator.stopAnimating()
            }
        }
    }
    
    @objc private func watchNowButtonPressed() {
        guard let nameFilm = nameFilm.text else { return }
        MultimediaLoader.shared.fetchWatchNowURL(with: nameFilm) { [weak self] url in
            DispatchQueue.main.async {
                self?.openSafariWebView(url: url)
            }
        }
    }

   private func openSafariWebView(url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.modalPresentationStyle = .automatic
        present(safariViewController, animated: true)
    }
    
    // MARK: - Action LeftBarButtonItem
    @objc private func buttonLeftPressed() {
        self.navigationController?.popToRootViewController(animated: true)
        print("buttonLeftPressed")
    }
    
    // MARK: - Action RightBarButtonItem
    @objc func buttonRightPressed(_ sender: UIBarButtonItem) {
        
        if let detailModel = detailModel {
            let movieModel = Movie(genreIds: [detailModel.genres.count], id: detailModel.id, overview: detailModel.overview, releaseDate: detailModel.releaseDate, title: detailModel.title, posterPath: detailModel.posterPath, voteAverage: detailModel.voteAverage, firstAirDate: detailModel.firstAirDate, name: detailModel.name)
            
            let isFavorite = databaseService.isInFavorites(detailModel.id)
            if isFavorite {
                RealmService.shared.deleteMovie(movieModel.id)
            } else {
                RealmService.shared.addToFavorites(movieModel, genre: .action)
//                add = true
            }
        }
        
        if let id = id {
            let pressed = databaseService.isInFavorites(id)
            navigationItem.rightBarButtonItem?.image = pressed ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            navigationItem.rightBarButtonItem?.tintColor = .red
        }
        
//        buttonTapped = !buttonTapped
//        sender.image = buttonTapped ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
//        sender.tintColor = buttonTapped ? .red : .gray
        
    }
    

    func updateStars(rating: Double) {
        let numberOfStars = Int(rating / 2)
        ratingLabel.text = String(format: "%.1f", rating)
        for (index, arrangedSubview) in starsStackView.arrangedSubviews.enumerated() {
            if let imageView = arrangedSubview as? UIImageView {
                imageView.image = index < numberOfStars ? UIImage(named: "star-4")?.withTintColor(#colorLiteral(red: 1, green: 0.7547127604, blue: 0.0322817266, alpha: 1)) : UIImage(named: "star-3")?.withTintColor(.systemGray)
            }
        }
    }

}

// MARK: - Configure BarButtonItem
extension DetailViewController {
    
    private func setupConstraints() {
        
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageFilm.translatesAutoresizingMaskIntoConstraints = false
        nameFilm.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        let starStack = UIStackView(arrangedSubviews: [ratingLabel, starsStackView], axis: .horizontal, spacing: 15)
        starStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageFilm)
        contentView.addSubview(nameFilm)
        contentView.addSubview(mainStack)
        contentView.addSubview(starStack)
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
        
        // MARK: - mainstack
        NSLayoutConstraint.activate([
            starStack.topAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: 16),
            starStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
        ])
        
        // MARK: - StoryLine label
        NSLayoutConstraint.activate([
            storyLineLabel.topAnchor.constraint(equalTo: starsStackView.bottomAnchor, constant: 32),
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
        let text = castArray[indexPath.item]
        
        var width = culculateWidth(size: 14, text: text.name)

        if text.character.count > text.name.count {
            
            width = culculateWidth(size: 12, text: text.character)
        }
        
        return CGSize(width: width, height: 50)
    }
    
    private func culculateWidth(size: CGFloat, text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: size, weight: .regular)
        let attributes = [NSAttributedString.Key.font : font as Any]
        let width = text.size(withAttributes: attributes).width + 80
        
        return width
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        40
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? CastAndCrewCell else { return UICollectionViewCell()}
        
        let cast = castArray[indexPath.item]
        cell.backgroundColor = .lightGray
        cell.titleLabel.text = cast.name
        cell.jobTitleLabel.text = cast.character
        if let cast = cast.profilePath {
            manager.fetchImage(from: cast) { image in
                
                if let image = image {
                    DispatchQueue.main.async {
                        cell.photoImageView.image = image
                    }
                }
                
            }
        }
        
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
