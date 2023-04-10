//
//  CastAndCrewCell.swift
//  Moviemax
//
//  Created by Андрей Фроленков on 6.04.23.
//

import Foundation
import UIKit

class CastAndCrewCell: UICollectionViewCell {
    
    let titleLabel = UILabel(text: "Jon Watts", font: UIFont.systemFont(ofSize: 14, weight: .medium), textColor: UIColor(named: K.Colors.titleColor))
    let jobTitleLabel = UILabel(text: "Director", font: UIFont.systemFont(ofSize: 10, weight: .regular), textColor: UIColor(named: K.Colors.titleColor))
    
    let photoImageView = UIImageView(image: UIImage(named: "photoImage"), contentMode: .scaleAspectFill)
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        photoImageView.layer.cornerRadius = 20
        layer.cornerRadius = contentView.frame.height / 2
    }
    
    func setupConstraints() {
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let titleStackView = UIStackView(arrangedSubviews: [titleLabel, jobTitleLabel], axis: .vertical, spacing: 5)
        titleStackView.alignment = .leading
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(photoImageView)
        contentView.addSubview(titleStackView)
        
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            photoImageView.heightAnchor.constraint(equalToConstant: 40),
            photoImageView.widthAnchor.constraint(equalToConstant: 40),
            photoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleStackView.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 8),
            titleStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
