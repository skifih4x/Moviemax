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
    var genre = "Action"
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
        
        manager.getMediaData(for: .movie) { [weak self] result in
            if let array = result[.movie] {
                self?.genreArray = array
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
        
        manager.fetchMoviesByGenre(genre: array.first ?? .action) { result in
            
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
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        
        let index = IndexPath(item: sender.tag, section: 0)
        guard let cell = tableView.cellForRow(at: index) as? CellFilmTableView else { return }
        cell.changeImageButton()
        
        //work with Realm
        let movie = genreArrayMovie[index.row]
        cell.buttonTapped
        ? databaseService.addToFavorites(movie, genre: genre)
        : databaseService.deleteMovie(movie)
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
//        let model = genreArray[indexPath.row]
//        cell.cellConfigure(with: model)
        let movie = genreArrayMovie[indexPath.row]
        
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
