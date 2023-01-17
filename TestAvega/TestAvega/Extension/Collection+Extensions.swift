//
//  Collection+Extensions.swift
//  TestAvega
//
//  Created by AlexKotov on 17.01.23.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
