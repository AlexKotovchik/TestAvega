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

struct Event: Codable, Hashable {
    let id: Int
    let title: String
    let images: [EventImage]
    let description: String
    let dates: [EventDates]

    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: Event, rhs: Event) -> Bool {
        lhs.id == rhs.id
    }
}

struct EventImage: Codable {
    let image: String
}

struct EventDates: Codable {
    let start: Double
    let end: Double
}
