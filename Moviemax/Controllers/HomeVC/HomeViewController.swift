//
//  HomeViewController.swift
//  Moviemax
//
//  Created by Андрей Фроленков on 3.04.23.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    //MARK: - properties
    private let categories: [MovieGenre] = [.action, .horror, .documentary, .animation]
    private var topMovies: [MultimediaViewModel] = []
    private var categoryMovies: [MultimediaViewModel] = []
    private let multimediaLoader = MultimediaLoader.shared
    private var databaseService: DatabaseService = RealmService.shared
    private var userService = RealmService.userAuth
    lazy var collectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BestMovieCell.self, forCellWithReuseIdentifier: String(describing: BestMovieCell.self))
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: String(describing: CategoryCell.self))
        collectionView.register(BoxOfficeCell.self, forCellWithReuseIdentifier: String(describing: BoxOfficeCell.self))
        
        collectionView.register(UserHeaderView.self, forSupplementaryViewOfKind: "UserHeader", withReuseIdentifier: UserHeaderView.headerIdentifier)
        collectionView.register(CategoryHeaderView.self, forSupplementaryViewOfKind: "CategoryHeader", withReuseIdentifier: CategoryHeaderView.headerIdentifier)
        collectionView.register(BoxOfficeHeaderView.self, forSupplementaryViewOfKind: "BoxOfficeHeader", withReuseIdentifier: BoxOfficeHeaderView.headerIdentifier)
        return collectionView
    }()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getInitialMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadSections(IndexSet(integer: 2))
    }
    
    //MARK: - private setup UI methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        setupConstrains()
        configureCompositionalLayout()
    }
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
}
//MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0 :
            return topMovies.count
        case 1 :
            return categories.count + 1
        default:
            return categoryMovies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BestMovieCell.self), for: indexPath) as? BestMovieCell else {fatalError("Could not create new cell")}
            let movie = topMovies[indexPath.item]
            cell.configure(with: movie)
            return cell
            
        case 1 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryCell.self), for: indexPath) as? CategoryCell else {fatalError("Could not create new cell")}
            if indexPath.item == 0 {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
                cell.configure(with: nil)
                return cell
            } else {
                let category = categories[indexPath.item - 1]
                cell.configure(with: category)
                return cell
            }
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BoxOfficeCell.self), for: indexPath) as? BoxOfficeCell else {fatalError("Could not create new cell")}
            let movie = categoryMovies[indexPath.item]
            //check if movie is favorite and set tapped heart
            if databaseService.isInFavorites(movie.id) {
                cell.changeImageButton()
            }
            cell.configure(with: movie)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 0:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: "UserHeader", withReuseIdentifier: UserHeaderView.headerIdentifier, for: indexPath) as? UserHeaderView else {fatalError("Could not create header")}
            let data = getUserData()
            header.setupUserData(with: data.0, data.1)
            return header
        case 1:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: "CategoryHeader", withReuseIdentifier: CategoryHeaderView.headerIdentifier, for: indexPath) as? CategoryHeaderView else {fatalError("Could not create header")}
            return header
        default:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: "BoxOfficeHeader", withReuseIdentifier: BoxOfficeHeaderView.headerIdentifier, for: indexPath) as? BoxOfficeHeaderView else {fatalError("Could not create header")}
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let detailViewController = DetailViewController()
            detailViewController.id = topMovies[indexPath.row].id
            detailViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(detailViewController, animated: true)
        case 1:
            if indexPath.row == 0 {
                getInitialMovies()
            } else {
                let genre = categories[indexPath.row - 1]
                fetchByGenre(genre: genre)
                collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
            }
        default:
            let detailViewController = DetailViewController()
            detailViewController.id = categoryMovies[indexPath.row].id
            detailViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    //MARK: fetching movies
    private func getInitialMovies() {
        multimediaLoader.fetchMultimedia(for: .movie) { [weak self] movieModel in
            guard let self = self else { return }
            DispatchQueue.global(qos: .userInitiated).async {
                let movies = self.multimediaLoader.getViewModelFromModel(model: movieModel, typeOfMedia: .movie)
                DispatchQueue.main.async {
                    self.topMovies = movies
                    self.categoryMovies = movies
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    private func fetchByGenre(genre: MovieGenre) {
        multimediaLoader.fetchMoviesByGenre(genre: genre) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                guard let movies = success.results else { return }
                let moviesModel = movies.map { MultimediaViewModel(id: $0.id, type: .movie, posterImageLink: $0.posterPath ?? "", titleName: $0.title ?? "", releaseDate: $0.releaseDate ?? "", genre: genre.name, description: $0.name ?? "", rating: $0.voteAverage)}
                self.categoryMovies = moviesModel.compactMap{$0}
                DispatchQueue.main.async {
                    self.collectionView.reloadSections(IndexSet(integer: 2))
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    //MARK: - user data
    private func getUserData() -> (String, URL?) {
        let userData = userService.getUserData()
        guard let firstName = userData?.userFirstName, let lastName = userData?.userLastName else { return ("", userData?.userImageUrl)}
        let name = "\(firstName) \(lastName)"
        let avatar = userData?.userImageUrl
        return (name, avatar)
    }
}

//MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    private func configureCompositionalLayout() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch sectionIndex {
            case 0:
                return self.bestMovieSection()
            case 1:
                return self.categorySection()
            default:
                return self.boxOfficeSection()
            }
        }
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func bestMovieSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        group.interItemSpacing = .fixed(120)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 120
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.6
                let maxScale: CGFloat = 1.0
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "UserHeader", alignment: .top)
        sectionHeader.pinToVisibleBounds = true
        sectionHeader.zIndex = 2
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func categorySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(34))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .paging
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "CategoryHeader", alignment: .top)
        sectionHeader.pinToVisibleBounds = true
        sectionHeader.zIndex = 2
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func boxOfficeSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.9))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(10)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "BoxOfficeHeader", alignment: .top)
        sectionHeader.pinToVisibleBounds = true
        sectionHeader.zIndex = 2
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
}
