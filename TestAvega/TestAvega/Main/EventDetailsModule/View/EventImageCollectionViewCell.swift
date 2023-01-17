//
//  EventImageCollectionViewCell.swift
//  TestAvega
//
//  Created by AlexKotov on 16.01.23.
//

import Foundation
import UIKit

class EventImageCollectionViewCell: UICollectionViewCell {
    var imageView: LoadingImageView = {
        let imageView = LoadingImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func layoutSubviews() {
        setupLayouts()
    }
    
    func setupLayouts() {
        contentView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            imageView.heightAnchor.constraint(equalToConstant: contentView.frame.width)
        ])
    }
    
    func configure(with imageUrl: String) {
        imageView.configure(with: imageUrl)
    }
}
