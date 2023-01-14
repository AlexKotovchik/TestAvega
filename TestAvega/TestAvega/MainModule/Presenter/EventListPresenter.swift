//
//  EventListPresenter.swift
//  TestAvega
//
//  Created by AlexKotov on 12.01.23.
//

import Foundation

protocol EventListViewProtocol: AnyObject {
    func presentEvents()
    func failure(error: Error)
}

protocol EventListPresenterProtocol: AnyObject {
    init(view: EventListViewProtocol, networkService: NetworkService)
    var events: [Event] { get set }
    var isNextLoading: Bool { get set }
    func getEventList(page: Int)
    func refresh()
    func loadNextPage(index: Int)
}

class EventListPresenter: EventListPresenterProtocol {
    weak var view: EventListViewProtocol?
    let networkService: NetworkService
    var events = [Event]()
    
    var totalEvents = 0
    var currentPage = 1
    var perPage = 20
    var isNextLoading = false
    
    required init(view: EventListViewProtocol, networkService: NetworkService) {
        self.view = view
        self.networkService = networkService
        getEventList(page: currentPage)
    }
    
    func loadNextPage(index: Int) {
        guard index == events.count - 1 else { return }
        guard totalEvents > events.count else { return }
        guard isNextLoading == false else { return }
        isNextLoading = true
        currentPage += 1
        getEventList(page: currentPage)
    }
    
    func refresh() {
        currentPage = 1
        getEventList(page: currentPage)
        events = []
    }
    
    func getEventList(page: Int) {
        networkService.getEventsList(page: String(page)) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                switch result {
                case .success(let eventList):
                    self.events.append(contentsOf: eventList.events)
                    self.totalEvents = eventList.count
                    self.isNextLoading = false
                    self.view?.presentEvents()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
}