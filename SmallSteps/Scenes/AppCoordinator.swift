//
//  AppCoordinator.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/9/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    private let window: UIWindow
    let databaseService: DatabaseService = CoreDataService(name: "SmallSteps")

    init(window: UIWindow) {
        self.window = window
    }

    override func start() {
        let tabBarController = UITabBarController()
        showActiveGoalsScene(tabBarController: tabBarController)
        showArchivedGoalsScene(tabBarController: tabBarController)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    func showActiveGoalsScene(tabBarController: UITabBarController) {
        let activeGoalListCoordinator = ActiveGoalListCoordinator(tabBarController: tabBarController, databaseService: databaseService)
        store(coordinator: activeGoalListCoordinator)
        activeGoalListCoordinator.isCompleted = { [weak self] in
            self?.free(coordinator: activeGoalListCoordinator)
        }
        activeGoalListCoordinator.start()
    }

    func showArchivedGoalsScene(tabBarController: UITabBarController) {
        let archivedGoalListCoordinator = ArchivedGoalListCoordinator(tabBarController: tabBarController, databaseService: databaseService)
        store(coordinator: archivedGoalListCoordinator)
        archivedGoalListCoordinator.isCompleted = { [weak self] in
            self?.free(coordinator: archivedGoalListCoordinator)
        }
        archivedGoalListCoordinator.start()
    }
}

