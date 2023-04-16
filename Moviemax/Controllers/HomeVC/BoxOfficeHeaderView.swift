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
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        label.text = "Box Office"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.topAnchor.constraint(equalTo: topAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
