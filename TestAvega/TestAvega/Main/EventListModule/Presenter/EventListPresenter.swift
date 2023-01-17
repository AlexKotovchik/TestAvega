//
//  EventListPresenter.swift
//  TestAvega
//
//  Created by AlexKotov on 12.01.23.
//

import Foundation

protocol EventListViewProtocol: AnyObject {
    func presentEvents()
    func showNextLoading()
    func failure(error: Error)
}

protocol EventListPresenterProtocol: AnyObject {
    init(view: EventListViewProtocol, networkService: NetworkServiceProtocol)
    var events: [Event] { get set }
    var isNextLoading: Bool { get set }
    func getEventList(page: Int)
    func refresh()
    func loadNextPage(index: Int)
}

class EventListPresenter: EventListPresenterProtocol {
    weak var view: EventListViewProtocol?
    let networkService: NetworkServiceProtocol
    var events = [Event]()
    
    var totalEvents = 0
    var currentPage = 1
    var perPage = 20
    var isNextLoading = false
    var isRefreshing = false
    
    required init(view: EventListViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
        getEventList(page: currentPage)
    }
    
    func loadNextPage(index: Int) {
        guard index == events.count - 1 else { return }
        guard totalEvents > events.count else { return }
        guard isNextLoading == false else { return }
        isNextLoading = true
        view?.showNextLoading()
        currentPage += 1
        getEventList(page: currentPage)
    }
    
    func refresh() {
        isRefreshing = true
        currentPage = 1
        getEventList(page: currentPage)
    }
    
    func getEventList(page: Int) {
        networkService.getEventsList(page: String(page)) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                switch result {
                case .success(let eventList):
                    if self.isRefreshing {
                        self.events = eventList.events
                    } else  {
                        self.events.append(contentsOf: eventList.events)
                    }
                    self.totalEvents = eventList.count
                    self.isNextLoading = false
                    self.isRefreshing = false
                    self.view?.presentEvents()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
}
