//
//  String+Extensions.swift
//  TestAvega
//
//  Created by AlexKotov on 13.01.23.
//

import Foundation

extension StringProtocol {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
}
