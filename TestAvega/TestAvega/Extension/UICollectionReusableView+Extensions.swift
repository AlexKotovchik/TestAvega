//
//  UICollectionViewCell+Extensions.swift
//  TestAvega
//
//  Created by AlexKotov on 13.01.23.
//

import UIKit

protocol Reusable {
    static var identifier: String { get }
}

extension Reusable {
    static var identifier: String {
        String(describing: Self.self)
    }
}

extension UICollectionReusableView: Reusable {
}



