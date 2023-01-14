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
}

class ModuleBuilder: BuilderProtocol {
    static func createEventListView() -> UIViewController {
        let view = EventListViewController()
        let presenter = EventListPresenter(view: view, networkService: NetworkService())
        view.presenter = presenter
        return view
    }
    
}
