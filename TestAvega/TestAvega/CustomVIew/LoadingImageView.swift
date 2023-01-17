//
//  LoadingImageView.swift
//  TestAvega
//
//  Created by AlexKotov on 17.01.23.
//

import Foundation
import UIKit

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
        progressView.startAnimating()
        ImageCacher.shared.download(imageUrl: imageUrl) { [weak self] image in
            guard let self = self else { return }
            self.image = image
            self.progressView.stopAnimating()
        }
    }
}
