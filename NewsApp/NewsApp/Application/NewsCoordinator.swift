//
//  AppCoordinator.swift
//  NewsApp
//
//  Created by Zagorovsky, Artem on 9/4/20.
//  Copyright © 2020 Artem Zagorovski. All rights reserved.
//

import UIKit

final class NewsCoordinator: DetailsShowable, ErrorShowable {
    weak var viewController: UIViewController?
    
    func createViewController(model: MainNewsDataProvider) -> UIViewController {
        let viewController = NewsViewController()
        self.viewController = viewController
        let controller = NewsController(model: model, view: viewController, coordinator: self)
        viewController.controller = controller
        return viewController
    }
}
