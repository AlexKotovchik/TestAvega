//
//  NetworkService.swift
//  TestAvega
//
//  Created by AlexKotov on 11.01.23.
//

import Foundation

public typealias JSONDict = [String: Any]

protocol NetworkServiceProtocol {
    func getEventsList(page: String, completion: @escaping (Result<EventList, Error>) -> Void)
}

enum NetworkError: Error {
    case invalidURL
    case clientError(Error)
    case serverError
    case badJson
}

class NetworkService: NetworkServiceProtocol {
    private enum API {
        static let events = "https://kudago.com/public-api/v1.4/events/?page=2&fields=id,title,images,dates&location=msk&page_size=100"
    }
    func getEventsList(page: String, completion: @escaping (Result<EventList, Error>) -> Void) {
        let parameters: JSONDict = ["location":"kzn",
                                    "fields":"id,title,images,dates",
                                    "page_size":"20",
                                    "page":page
        ]
        guard let url = URL.url(with: API.events, queryParams: parameters) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.clientError(error)))
            }
            guard let httpResponse = response as? HTTPURLResponse,
                        (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.serverError))
                        return
            }
            guard let data = data,
                  let result = try? JSONDecoder().decode(EventList.self, from: data) else {
                completion(.failure(NetworkError.badJson))
                return
            }
            completion(.success(result))
        }
        task.resume()
    }
    
    
}
