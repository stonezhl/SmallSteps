//
//  ActiveGoalListCoordinator.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/9/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit

class ActiveGoalListCoordinator: BaseCoordinator {
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
        let viewModel = DefaultActiveGoalListViewModel(databaseService: databaseService)
        let viewController = ActiveGoalListViewController(viewModel: viewModel)
        viewController.title = "Goals"
        viewModel.enterCreateGoalSecene = { [weak self] in
            self?.showCreateGoalScene()
        }
        navigation.pushViewController(viewController, animated: false, backClosure: isCompleted)
        tabBarController.addChild(navigation.navigationController)
    }

    func showCreateGoalScene() {
        let createGoalCoordinator = CreateGoalCoordinator(navigation: navigation, databaseService: databaseService)
        store(coordinator: createGoalCoordinator)
        createGoalCoordinator.isCompleted = { [weak self] in
            self?.free(coordinator: createGoalCoordinator)
        }
        createGoalCoordinator.start()
    }
}
