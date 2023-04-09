//
//  SearchViewController.swift
//  Moviemax
//
//  Created by Андрей Фроленков on 3.04.23.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    let array = ["mfdvmfmvfmerferferferfer", "dfjvmkfdffdf", "sdjjsj"]
    var indexCell = 0
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate   = self
        
        tableView.delegate        = self
        tableView.dataSource      = self
        
        searchBar.delegate = self
        
        self.tableView.register(CellFilmTableView.self, forCellReuseIdentifier: "CellForTable")
        self.collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "Cell")
        
        view.backgroundColor = UIColor(named: K.Colors.background)
        setupConstraints()
        settingsNavigationBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let image = UIImage(named: "Combined-Shape") {
            guard let color = UIColor(named: K.Colors.titleColor) else { return }
            searchBar.setRightImage(image)
            searchBar.textField?.rightView?.tintColor = UIColor(named: K.Colors.titleColor)
            searchBar.changePlaceholderColor(color)
        }
        
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        
        let index = IndexPath(item: sender.tag, section: 0)
        guard let cell = tableView.cellForRow(at: index) as? CellFilmTableView else { return }
        cell.changeImageButton()
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.isLoading = !self.searchBar.isLoading
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellForTable", for: indexPath) as? CellFilmTableView else { return UITableViewCell()}
        cell.filmImageView.image = UIImage(named: "image1")
        cell.likeButton.tag = indexPath.row
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
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
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
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
