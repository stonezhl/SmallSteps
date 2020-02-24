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
        let viewModel = DefaultArchivedGoalListViewModel(databaseService: databaseService)
        let viewController = ArchivedGoalListViewController(viewModel: viewModel)
        viewController.title = "Archived"
        viewModel.enterGoalDetailScene = { [weak self] goal in
            self?.showGoalDetailScene(goal: goal)
        }
        navigation.pushViewController(viewController, animated: false, backClosure: isCompleted)
        tabBarController.addChild(navigation.navigationController)
    }

    func showGoalDetailScene(goal: Goal) {
        let goalDetailCoordinator = GoalDetailCoordinator(navigation: navigation, databaseService: databaseService, goal: goal)
        store(coordinator: goalDetailCoordinator)
        goalDetailCoordinator.isCompleted = { [weak self] in
            self?.free(coordinator: goalDetailCoordinator)
        }
        goalDetailCoordinator.start()
    }
}
