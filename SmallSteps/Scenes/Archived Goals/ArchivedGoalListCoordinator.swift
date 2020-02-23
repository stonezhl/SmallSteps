//
//  ArchivedGoalListCoordinator.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/9/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit

class ArchivedGoalListCoordinator: BaseCoordinator {
    private let tabBarController: UITabBarController
    private let databaseService: DatabaseService

    lazy var navigation: AppNavigation = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        return AppNavigation(navigationController: navigationController)
    }()

    init(tabBarController: UITabBarController, databaseService: DatabaseService) {
        self.tabBarController = tabBarController
        self.databaseService = databaseService
    }

    override func start() {
        let viewController = ArchivedGoalListViewController()
        viewController.title = "Archived"
        navigation.pushViewController(viewController, animated: false, backClosure: isCompleted)
        tabBarController.addChild(navigation.navigationController)
    }
}
