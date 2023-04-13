//
//  SearchViewController.swift
//  Moviemax
//
//  Created by Андрей Фроленков on 3.04.23.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    private let databaseService: DatabaseService = RealmService.shared
    var arrayMovie: [MultimediaViewModel]?
    let allGenresArray = MovieGenre.allCases
    var search = ""
    var searchFlag = false
    var currentGenre: MovieGenre = .action
    var genreArray = [Movie]()
    var indexCell = 0 {
        didSet {
            print(indexCell)
        }
    }
    
    let manager = MultimediaLoader.shared
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let searchBar: CustomSearchBar = {
        let searchBar = CustomSearchBar()
        
        return searchBar
    }()

    var filterButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()
//        arrayMovie = RealmService.shared.fetchFavorites()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        collectionView.dataSource = self
        collectionView.delegate   = self
        
        tableView.delegate        = self
        tableView.dataSource      = self
        
        searchBar.delegate = self
        
        searchBar.textField?.delegate = self
        
        self.tableView.register(CellFilmTableView.self, forCellReuseIdentifier: "CellForTable")
        self.collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "Cell")
        
        view.backgroundColor = UIColor(named: K.Colors.background)
        setupConstraints()
        settingsNavigationBar()
        setupVisualEffectView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        if searchFlag {
            manager.searchMedia(type: .movie, query: search) { result in
                
                switch result {
                    
                case .success(let arrayModel):
                    if let array = arrayModel.results {
                        print(array)
                        self.genreArray = array
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        } else {
            manager.fetchMoviesByGenre(genre: allGenresArray.first ?? .action) { result in
                
                switch result {
                    
                case .success(let arrayModel):
                    if let array = arrayModel.results {
                        self.genreArray = array
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    var visualEffectView: UIVisualEffectView!

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let image = UIImage(named: "Combined-Shape") {
            guard let color = UIColor(named: K.Colors.titleColor) else { return }
            filterButton = searchBar.setRightImage(image)
            searchBar.textField?.rightView?.tintColor = UIColor(named: K.Colors.titleColor)
            searchBar.changePlaceholderColor(color)
        }

        filterButton?.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
        
    }

    @objc
    private func filterButtonPressed() {
            let customModalVC = FilterModalViewController()
            customModalVC.delegate = self
            customModalVC.modalPresentationStyle = .custom
            customModalVC.modalTransitionStyle = .coverVertical
            customModalVC.transitioningDelegate = self
            present(customModalVC, animated: true, completion: nil)

            // Animate the blur effect
            UIView.animate(withDuration: 0.3) {
                self.visualEffectView.alpha = 1
            }
    }

    func setupVisualEffectView() {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.bounds
        visualEffectView.alpha = 0
        self.view.addSubview(visualEffectView)
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        let index = IndexPath(item: sender.tag, section: 0)
        
        guard let cell = tableView.cellForRow(at: index) as? CellFilmTableView else { return }
        let model = genreArray[index.row]
        if databaseService.isInFavorites(model.id) {
            databaseService.deleteMovie(model.id)
        } else {
            RealmService.shared.addToFavorites(model, genre: currentGenre)
        }
        cell.changeImageButton()
        tableView.reloadData()
    }
}

extension SearchViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
}

extension SearchViewController: FilterViewControllerDelegate {
    func filterApplied(category: MovieGenre?, starRating: Double?) {
        UIView.animate(withDuration: 0.3) {
            self.visualEffectView.alpha = 0
        }

        if category == nil && starRating == nil { return }

        let genre = category ?? .all
        let rating = Int(starRating ?? 0)

        manager.fetchMoviesByGenreAndRating(genre: genre, rating: rating) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let arrayModel):
                if let array = arrayModel.results {
                    self.genreArray = array
                    DispatchQueue.main.async {
                        if let newCategoryIndex = self.allGenresArray.firstIndex(where: { $0 == genre }) {
                            self.currentGenre = self.allGenresArray[newCategoryIndex]
                            guard let currentCell = self.collectionView.cellForItem(at: IndexPath(item: self.indexCell, section: 0)) as? CustomCell else { return }
                            currentCell.backgroundColor = .clear
                            currentCell.titleLabel.textColor = #colorLiteral(red: 0.6117647059, green: 0.6431372549, blue: 0.6705882353, alpha: 1)
                            let selectedCellIndexPath = IndexPath(item: newCategoryIndex, section: 0)
                            self.collectionView.scrollToItem(at: selectedCellIndexPath, at: .centeredHorizontally, animated: true)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.indexCell = newCategoryIndex
                                guard let selectedCell = self.collectionView.cellForItem(at: selectedCellIndexPath) as? CustomCell else { return }
                                selectedCell.backgroundColor = #colorLiteral(red: 0.3176470588, green: 0.3058823529, blue: 0.7137254902, alpha: 1)
                                selectedCell.titleLabel.textColor = .white
                                self.tableView.reloadData()
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
                case .failure(let failure):
                    print(failure)
                }
        }
    }
}


// MARK: - UISearchTextFieldDelegat
extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let text = textField.text {
            search = text
            print(search)
            manager.searchMedia(type: .movie, query: text) { result in
                
                switch result {
                    
                case .success(let arrayModel):
                    if let array = arrayModel.results {
                        self.searchFlag = true
                        self.genreArray = array
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            print("false")
        }
        return false
    }
    
    
    
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.isLoading = !self.searchBar.isLoading
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            print("wow")
            manager.fetchMoviesByGenre(genre: allGenresArray.first ?? .action) { result in
                
                switch result {
                    
                case .success(let arrayModel):
                    if let array = arrayModel.results {
                        print(array)
                        self.genreArray = array
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            
           

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                self.tableView.reloadData()
            }

        }
    }
}

// MARK: - Settings NavigationBar
extension SearchViewController {
    
    private func settingsNavigationBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: K.Colors.background)
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: K.Colors.titleColor) ?? .white,
                                          .font: UIFont.systemFont(ofSize: 24, weight: .bold)
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

// MARK: - Setup Constraints
extension SearchViewController {
    
    func setupConstraints() {
        
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(tableView)
        
        // CollectionView
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
        ])
        
        // CollectionView
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // TableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor,constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellForTable", for: indexPath) as? CellFilmTableView else { return UITableViewCell()}
        
        
        let movie = genreArray[indexPath.row]
        
        //check if movie is favorite and set tapped heart
        if databaseService.isInFavorites(movie.id) {
            let image = UIImage(systemName: "heart.fill")
            cell.likeButton.setImage(image, for: .normal)
        }
        
        cell.cellConfigureMovie(with: movie, genre: currentGenre)
        
        cell.likeButton.tag = indexPath.row
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = DetailViewController()
        detailViewController.id = genreArray[indexPath.row].id
        detailViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = allGenresArray[indexPath.item]
        let width = text.name.count * 10 + 40
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
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allGenresArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CustomCell else { return UICollectionViewCell()}
        if indexCell == indexPath.item {
            cell.backgroundColor = #colorLiteral(red: 0.3176470588, green: 0.3058823529, blue: 0.7137254902, alpha: 1)
            cell.titleLabel.textColor = .white
        } else {
            cell.backgroundColor = .clear
            cell.titleLabel.textColor = #colorLiteral(red: 0.6117647059, green: 0.6431372549, blue: 0.6705882353, alpha: 1)
        }
        let width = allGenresArray[indexPath.item]
        cell.titleLabel.text = width.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexCell = indexPath.item
        
        currentGenre = allGenresArray[indexPath.row]
        
        manager.fetchMoviesByGenre(genre: allGenresArray[indexPath.row]) { result in
            
            switch result {
                
            case .success(let arrayModel):
                if let array = arrayModel.results {
                    self.genreArray = array
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            case .failure(let error): 
                print(error.localizedDescription)
            }
        }
        
        DispatchQueue.main.async {
            collectionView.reloadData()
        }
        
    }
}
