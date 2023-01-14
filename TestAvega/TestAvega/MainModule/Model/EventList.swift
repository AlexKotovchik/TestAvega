//
//  EventsList.swift
//  TestAvega
//
//  Created by AlexKotov on 11.01.23.
//

import Foundation

struct EventList: Codable {
    let count: Int
    let next: String
    let events: [Event]
    
    enum CodingKeys: String, CodingKey {
        case count, next
        case events = "results"
    }
}

struct Event: Codable {
    let id: Int
    let title: String
    let images: [EventImage]
//    let description: String
    let dates: [EventDates]
    
    enum CodingKeys: String, CodingKey {
        case id, title, images, dates
//        case description = "resultDescription"
    }
}

struct EventImage: Codable {
    let image: String
}

struct EventDates: Codable {
    let start: Int
    let end: Int
}
