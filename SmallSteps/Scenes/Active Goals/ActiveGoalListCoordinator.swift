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

    lazy var navigation: AppNavigation = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        return AppNavigation(navigationController: navigationController)
    }()

    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }

    override func start() {
        let viewController = ActiveGoalListViewController()
        viewController.title = "Goals"
        navigation.pushViewController(viewController, animated: false, backClosure: isCompleted)
        tabBarController.addChild(navigation.navigationController)
    }
}
