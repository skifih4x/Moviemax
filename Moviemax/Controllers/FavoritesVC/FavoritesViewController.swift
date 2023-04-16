//
//  FavoritesViewController.swift
//  Moviemax
//
//  Created by Андрей Фроленков on 3.04.23.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController {
    
    var arrayMovie: [MultimediaViewModel]?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        arrayMovie = RealmService.shared.fetchFavorites()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        
        let index = IndexPath(row: sender.tag, section: 0)
        guard let cell = tableView.cellForRow(at: index) as? CellFilmTableView else { return }
        guard let arrayMovie = arrayMovie else { return }
        let model = arrayMovie[index.row]
       
        if model.isFavorite {
            RealmService.shared.deleteMovie(model.id)
            self.arrayMovie?.remove(at: index.row)
            self.tableView.reloadData()
        }
        
        
        cell.changeImageButton()
    }
}



// MARK: - Settings NavigationBar
extension FavoritesViewController {
    
    private func settingsNavigationBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: K.Colors.background)
        appearance.titleTextAttributes = [.foregroundColor:UIColor(named: K.Colors.titleColor) ?? "",
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
extension FavoritesViewController {
    
    func setupConstraints() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // TableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMovie?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellForTable", for: indexPath) as? CellFilmTableView else { return UITableViewCell()}
        
        if let arrayMovie = arrayMovie {
            let model = arrayMovie[indexPath.row]
            let image = model.isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            print(model.isFavorite)
            cell.likeButton.setImage(image, for: .normal)
            cell.cellConfigure(with: model)
            cell.likeButton.tag = indexPath.row
        }
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         guard var arrayMovie = arrayMovie else { return UISwipeActionsConfiguration() }
         let model = arrayMovie[indexPath.row]
        
        let action = UIContextualAction(style: .destructive,
                                        title: "Delete") { (action, view, completionHandler) in
            RealmService.shared.deleteMovie(model.id)
            self.arrayMovie?.remove(at: indexPath.row)
            self.tableView.reloadData()
            completionHandler(true)
        }
        action.image = UIImage(systemName: "basket")
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailViewController()
        if let arrayMovie = arrayMovie {
            detail.id = arrayMovie[indexPath.row].id
            tableView.deselectRow(at: indexPath, animated: true)
            self.navigationController?.pushViewController(detail, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
}
