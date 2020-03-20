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
    private let dataCenter: DataCenter

    lazy var navigation: AppNavigation = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.tintColor = .label
        return AppNavigation(navigationController: navigationController)
    }()

    init(tabBarController: UITabBarController, dataCenter: DataCenter) {
        self.tabBarController = tabBarController
        self.dataCenter = dataCenter
    }

    override func start() {
        let viewModel = DefaultActiveGoalListViewModel(dataCenter: dataCenter)
        let viewController = ActiveGoalListViewController(viewModel: viewModel)
        viewController.title = NSLocalizedString("Goals", comment: "Title of active goals scene")
        viewModel.enterCreateGoalScene = { [weak self] in
            self?.showCreateGoalScene()
        }
        viewModel.enterArchivedGoalsScene = { [weak self] in
            self?.showArchivedGoalsScene()
        }
        viewModel.enterGoalDetailScene = { [weak self] goal in
            self?.showGoalDetailScene(goal: goal)
        }
        navigation.pushViewController(viewController, animated: false, backClosure: isCompleted)
        tabBarController.addChild(navigation.navigationController)
    }

    func showCreateGoalScene() {
        let createGoalCoordinator = CreateGoalCoordinator(navigation: navigation, dataCenter: dataCenter)
        store(coordinator: createGoalCoordinator)
        createGoalCoordinator.isCompleted = { [weak self] in
            self?.free(coordinator: createGoalCoordinator)
        }
        createGoalCoordinator.start()
    }

    func showArchivedGoalsScene() {
        let archivedGoalListCoordinator = ArchivedGoalListCoordinator(navigation: navigation, dataCenter: dataCenter)
        store(coordinator: archivedGoalListCoordinator)
        archivedGoalListCoordinator.isCompleted = { [weak self] in
            self?.free(coordinator: archivedGoalListCoordinator)
        }
        archivedGoalListCoordinator.start()
    }

    func showGoalDetailScene(goal: Goal) {
        let goalDetailCoordinator = GoalDetailCoordinator(navigation: navigation, dataCenter: dataCenter, goal: goal)
        store(coordinator: goalDetailCoordinator)
        goalDetailCoordinator.isCompleted = { [weak self] in
            self?.free(coordinator: goalDetailCoordinator)
        }
        goalDetailCoordinator.start()
    }
}
