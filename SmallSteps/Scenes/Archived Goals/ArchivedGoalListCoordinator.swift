//
//  ArchivedGoalListCoordinator.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/9/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit

class ArchivedGoalListCoordinator: BaseCoordinator {
    private let presentingNavigation: AppNavigation
    private let databaseService: DatabaseService

    lazy var navigation: AppNavigation = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.tintColor = .label
        return AppNavigation(navigationController: navigationController)
    }()

    init(navigation: AppNavigation, databaseService: DatabaseService) {
        self.presentingNavigation = navigation
        self.databaseService = databaseService
    }

    override func start() {
        let viewModel = DefaultArchivedGoalListViewModel(databaseService: databaseService)
        let viewController = ArchivedGoalListViewController(viewModel: viewModel)
        viewModel.enterGoalDetailScene = { [weak self] goal in
            self?.showGoalDetailScene(goal: goal)
        }
        viewModel.didExitScene = { [weak self] in
            self?.isCompleted?()
        }
        navigation.pushViewController(viewController, animated: false, backClosure: isCompleted)
        presentingNavigation.present(navigation.navigationController, animated: true)
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
