//
//  ImageCacher.swift
//  TestAvega
//
//  Created by AlexKotov on 16.01.23.
//

import Foundation
import UIKit

class ImageCacher {
    static var shared = ImageCacher()
    
    let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        return cache
    }()
    
    func download(imageUrl: String, completion: @escaping (UIImage) -> Void) {
        let nsUrl = NSString(string: imageUrl)
        if let cachedImage = cache.object(forKey: nsUrl) {
            completion(cachedImage)
        } else {
            DispatchQueue.global().async {
                if let url = URL(string: imageUrl),
                   let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    self.cache.setObject(image, forKey: nsUrl)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        completion(image)
                    }
                } else {
                    let placeholderImage = UIImage(named: "placeholder") ?? UIImage()
                    self.cache.setObject(placeholderImage, forKey: nsUrl)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        completion(placeholderImage)
                    }
                }
            }
        }
    }
}
