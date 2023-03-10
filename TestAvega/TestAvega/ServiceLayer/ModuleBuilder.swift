//
//  ModuleBuilder.swift
//  TestAvega
//
//  Created by AlexKotov on 12.01.23.
//

import Foundation
import UIKit

protocol BuilderProtocol {
    static func createEventListView() -> UIViewController
    static func createEventDetailView(event: Event) -> UIViewController
}

class ModuleBuilder: BuilderProtocol {
    static func createEventListView() -> UIViewController {
        let view = EventListViewController()
        let presenter = EventListPresenter(view: view, networkService: NetworkService())
        view.presenter = presenter
        return view
    }
    
    static func createEventDetailView(event: Event) -> UIViewController {
        let view = EventDetailsViewController()
        let presenter = EventDetailsPresenter(view: view, networkService: NetworkService(), event: event)
        view.presenter = presenter
        return view
    }
    
}
