//
//  EventCollectionViewCell.swift
//  TestAvega
//
//  Created by AlexKotov on 13.01.23.
//

import Foundation
import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = label.font.withSize(10)
        label.numberOfLines = 5
        return label
    }()
    
    var progressView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.stopAnimating()
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    override func layoutSubviews() {
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayouts() {
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.addSubview(progressView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageView.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            imageView.heightAnchor.constraint(equalToConstant: contentView.frame.width)
        ])
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -4),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4)
        ])
    }
    
    func configure(with event: Event?) {
        guard let event = event else { return }
        progressView.startAnimating()
        DispatchQueue.global().async {
            if let url = URL(string: event.images.first?.image ?? ""),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.progressView.stopAnimating()
                }
            } else {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(named: "placeholder")
                    self.progressView.stopAnimating()
                }
            }
        }
        
        
        label.text = event.title.firstUppercased
    }
    
}

