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
    
    let cache: NSCache<NSNumber, UIImage> = {
        let cache = NSCache<NSNumber, UIImage>()
        cache.countLimit = 100
        return cache
    }()
    
    func download(event: Event, completion: @escaping (UIImage) -> Void) {
        let eventID = NSNumber(value: event.id)
        //        if let cachedImage = cache.object(forKey: eventID) {
        //            completion(cachedImage)
        //        } else {
        DispatchQueue.global().async {
            if let url = URL(string: event.images.first?.image ?? ""),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: eventID)
                completion(image)
            } else {
                let placeholderImage = UIImage(named: "placeholder") ?? UIImage()
                self.cache.setObject(placeholderImage, forKey: eventID)
                completion(placeholderImage)
            }
        }
        //        }
    }
}
