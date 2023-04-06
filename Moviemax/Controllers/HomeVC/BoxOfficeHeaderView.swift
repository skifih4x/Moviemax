//
//  BoxOfficeHeaderView.swift
//  Moviemax
//
//  Created by Жадаев Алексей on 05.04.2023.
//

import UIKit

final class BoxOfficeHeaderView: UICollectionReusableView {
    //MARK: - properties
    static let headerIdentifier = "BoxOfficeHeaderView"
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        label.text = "Box Office"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBackground
        button.tintColor = #colorLiteral(red: 0.3176470588, green: 0.3058823529, blue: 0.7137254902, alpha: 1)
        button.setTitle("See All", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //MARK: - private setup methods
    private func setupView() {
        backgroundColor = .systemBackground
        addSubview(title)
        addSubview(seeAllButton)
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.topAnchor.constraint(equalTo: topAnchor),
            title.widthAnchor.constraint(equalToConstant: 83),
            title.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            seeAllButton.leadingAnchor.constraint(greaterThanOrEqualTo: title.trailingAnchor),
            seeAllButton.topAnchor.constraint(equalTo: topAnchor),
            seeAllButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            seeAllButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
