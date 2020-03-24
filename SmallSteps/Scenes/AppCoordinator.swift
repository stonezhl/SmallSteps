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
    let dataCenter: DataCenter = AppDataCenter()

    init(window: UIWindow) {
        self.window = window
        super.init()
        dataCenter.appAppearance.addObserver(self, initialNotificationType: .sync) { [weak self] appearance in
            switch appearance {
            case .system:
                self?.window.overrideUserInterfaceStyle = .unspecified
            case .light:
                self?.window.overrideUserInterfaceStyle = .light
            case .dark:
                self?.window.overrideUserInterfaceStyle = .dark
            }
        }
    }

    override func start() {
        let tabBarController = UITabBarController()
        showActiveGoalsScene(tabBarController: tabBarController)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    func showActiveGoalsScene(tabBarController: UITabBarController) {
        let activeGoalListCoordinator = ActiveGoalListCoordinator(tabBarController: tabBarController, dataCenter: dataCenter)
        store(coordinator: activeGoalListCoordinator)
        activeGoalListCoordinator.isCompleted = { [weak self] in
            self?.free(coordinator: activeGoalListCoordinator)
        }
        activeGoalListCoordinator.start()
    }
}

