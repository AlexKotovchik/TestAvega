//
//  Double+Extensions.swift
//  TestAvega
//
//  Created by AlexKotov on 16.01.23.
//

import Foundation

extension Double {
    func convertToDate() -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM.dd.yyyy HH:mm"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}
