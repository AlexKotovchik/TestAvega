//
//  URL+Extensions.swift
//  TestAvega
//
//  Created by AlexKotov on 14.01.23.
//

import Foundation

extension URL {
    static func url(with path: String,
                    queryParams: JSONDict) -> URL? {
        guard let url = URL(string: path),
              var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil}
        urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0, value: "\($1)")}
        return urlComponents.url
    }
}
