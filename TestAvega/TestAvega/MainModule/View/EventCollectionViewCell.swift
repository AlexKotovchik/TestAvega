//
//  EventCollectionViewCell.swift
//  TestAvega
//
//  Created by AlexKotov on 13.01.23.
//

import Foundation
import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    var imageView: LoadingImageView = {
        let imageView = LoadingImageView()
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
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    override func layoutSubviews() {
        setupLayouts()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        label.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayouts() {
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageView.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            imageView.heightAnchor.constraint(equalToConstant: contentView.frame.width)
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
        let imageUrl = event.images.first?.image ?? ""
        imageView.configure(with: imageUrl)
        label.text = event.title.firstUppercased
    }
    
}

class LoadingImageView: UIImageView {
    var progressView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.stopAnimating()
        return spinner
    }()
    
    override func layoutSubviews() {
        setupLayouts()
    }
    
    func setupLayouts() {
        self.addSubview(progressView)
    
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func configure(with imageUrl: String) {
        let nsUrl = NSString(string: imageUrl)
        if let cachedImage = ImageCacher.shared.cache.object(forKey: nsUrl) {
            self.image = cachedImage
        } else {
            progressView.startAnimating()
            ImageCacher.shared.download(imageUrl: imageUrl) { image in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.image = image
                    self.progressView.stopAnimating()
                }
            }
        }
    }
}
