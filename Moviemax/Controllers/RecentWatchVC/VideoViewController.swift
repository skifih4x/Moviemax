//
//  VideoViewController.swift
//  Moviemax
//
//  Created by Андрей Фроленков on 3.04.23.
//

import Foundation
import UIKit

class VideoViewController: UIViewController {
    let databaseService: DatabaseService = RealmService.shared
    
    var array = MovieGenre.allCases
    var genreArrayMovie = [Movie]()
    var genre: MovieGenre = .action
    var genreArray = [MultimediaViewModel]()
    var indexCell = 0
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate        = self
        tableView.dataSource      = self
        
        self.tableView.register(CellFilmTableView.self, forCellReuseIdentifier: "CellForTable")
        
        view.backgroundColor = UIColor(named: K.Colors.background)
        setupConstraints()
        settingsNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            self.genreArrayMovie = self.fetchRecentWatch()
            print(self.genreArrayMovie.count)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

//        manager.getMediaData(for: .movie) { [weak self] result in
//            if let array = result[.movie] {
//                self?.genreArrayMovie = array
//
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//                }
//            }
//        }
//
//        manager.fetchMoviesByGenre(genre: array.first ?? .action) { result in
//
//            switch result {
//
//            case .success(let arrayModel):
//                if let array = arrayModel.results {
//                    self.genreArrayMovie = array
//
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        
        let index = IndexPath(item: sender.tag, section: 0)
        guard let cell = tableView.cellForRow(at: index) as? CellFilmTableView else { return }
        cell.changeImageButton()
        
        //work with Realm
        let movie = genreArrayMovie[index.row]
        cell.buttonTapped
        ? databaseService.addToFavorites(movie, genre: genre)
        : databaseService.deleteMovie(movie.id)
    }
}

//MARK: - Database methods
extension VideoViewController {
    func fetchRecentWatch() -> [Movie] {
        let data = databaseService.fetchRecentWatch()
        let movies = data.map { Movie(genreIds: [1], id: $0.id, overview: $0.description, releaseDate: $0.releaseDate, title: $0.titleName, posterPath: $0.posterImageLink, voteAverage: $0.rating, firstAirDate: $0.releaseDate, name: $0.titleName) }
        return movies
    }
}

// MARK: - Settings NavigationBar
extension VideoViewController {
    
    private func settingsNavigationBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: K.Colors.background)
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: K.Colors.titleColor) ?? "",
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
extension VideoViewController {
    
    func setupConstraints() {
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        view.addSubview(tableView)
        
        // TableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension VideoViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreArrayMovie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellForTable", for: indexPath) as? CellFilmTableView else { return UITableViewCell()}
        
        cell.likeButton.tag = indexPath.row
        let movie = genreArrayMovie[indexPath.row]
        //check if movie is favorite and set tapped heart
        if databaseService.isInFavorites(movie.id) {
            let image = UIImage(systemName: "heart.fill")
            cell.likeButton.setImage(image, for: .normal)
        }
        cell.cellConfigureMovie(with: movie, genre: genre)
       
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.id = genreArrayMovie[indexPath.row].id
        detailViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension VideoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = array[indexPath.item]
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
extension VideoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CustomCell else { return UICollectionViewCell()}
        if indexCell == indexPath.item {
            cell.backgroundColor = #colorLiteral(red: 0.3176470588, green: 0.3058823529, blue: 0.7137254902, alpha: 1)
        } else {
            cell.backgroundColor = .clear
        }
        let width = array[indexPath.item]
        cell.titleLabel.text = width.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexCell = indexPath.item
        
        genre = array[indexPath.row]
        
        manager.fetchMoviesByGenre(genre: array[indexPath.row]) { result in
            
            switch result {
                
            case .success(let arrayModel):
                if let array = arrayModel.results {
                    self.genreArrayMovie = array
                    
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
