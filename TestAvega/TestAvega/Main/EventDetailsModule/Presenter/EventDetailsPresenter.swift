//
//  EventDetailsPresenter.swift
//  TestAvega
//
//  Created by AlexKotov on 16.01.23.
//

import Foundation

protocol EventDetailsViewProtocol: AnyObject {
    func setEvent(event: Event)
}

protocol EventDetailsPresenterProtocol: AnyObject {
    init(view: EventDetailsViewProtocol, networkService: NetworkServiceProtocol, event: Event)
    var event: Event { get }
    func setEvent()
}

class EventDetailsPresenter: EventDetailsPresenterProtocol {
    weak var view: EventDetailsViewProtocol?
    let networkService: NetworkServiceProtocol
    var event: Event
    
    required init(view: EventDetailsViewProtocol, networkService: NetworkServiceProtocol, event: Event) {
        self.view = view
        self.networkService = networkService
        self.event = event
    }
    
    func setEvent() {
        view?.setEvent(event: event)
    }
    
}
