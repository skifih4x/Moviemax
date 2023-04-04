//
//  GenreView.swift
//  Moviemax
//
//  Created by Андрей Фроленков on 4.04.23.
//

import Foundation
import UIKit

class GenreView: UIView {
    
    let genreLabel: UILabel = {
        let label = UILabel()
        label.text = "Action"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 0.8901960784, green: 0.9137254902, blue: 0.9294117647, alpha: 1)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.3176470588, green: 0.3058823529, blue: 0.7137254902, alpha: 1)
        setupConstraints()
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(genreLabel)
        
        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            genreLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            genreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            genreLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
        ])
    }
}
