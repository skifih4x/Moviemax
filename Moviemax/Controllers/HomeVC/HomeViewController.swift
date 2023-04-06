//
//  HomeViewController.swift
//  Moviemax
//
//  Created by Андрей Фроленков on 3.04.23.
//

import UIKit

class HomeViewController: UIViewController {
    //MARK: - properties
    private let categories = ["All", "Action", "Adventure", "Mystery"]
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
            return 3
        case 1 :
            return 4
        default:
            return 8
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BestMovieCell.self), for: indexPath) as? BestMovieCell else {fatalError("Could not create new cell")}
            cell.configure(title: "Thor: Love and Thunder", genre: "Action")
            return cell
            
        case 1 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryCell.self), for: indexPath) as? CategoryCell else {fatalError("Could not create new cell")}
            if indexPath.item == 0 {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
            }
            let title = categories[indexPath.item]
            cell.configure(title: title)
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BoxOfficeCell.self), for: indexPath) as? BoxOfficeCell else {fatalError("Could not create new cell")}
            cell.configure(title: "Drifting Home", genre: "Action")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 0:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: "UserHeader", withReuseIdentifier: UserHeaderView.headerIdentifier, for: indexPath) as? UserHeaderView else {fatalError("Could not create header")}
            return header
        case 1:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: "CategoryHeader", withReuseIdentifier: CategoryHeaderView.headerIdentifier, for: indexPath) as? CategoryHeaderView else {fatalError("Could not create header")}
            return header
        default:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: "BoxOfficeHeader", withReuseIdentifier: BoxOfficeHeaderView.headerIdentifier, for: indexPath) as? BoxOfficeHeaderView else {fatalError("Could not create header")}
            return header
        }
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
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 22, leading: 0, bottom: 50, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.8
                let maxScale: CGFloat = 1.0
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "UserHeader", alignment: .top)
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
        section.orthogonalScrollingBehavior = .continuous
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "CategoryHeader", alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func boxOfficeSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 24)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.35))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 24)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "BoxOfficeHeader", alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
}
