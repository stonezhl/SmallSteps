//
//  GoalDetailCoordinator.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/24/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit

class GoalDetailCoordinator: BaseCoordinator {
    private let navigation: Navigation
    private let databaseService: DatabaseService
    private let goal: Goal

    init(navigation: Navigation, databaseService: DatabaseService, goal: Goal) {
        self.navigation = navigation
        self.databaseService = databaseService
        self.goal = goal
    }

    override func start() {
        let viewModel = DefaultGoalDetailViewModel(databaseService: databaseService, goal: goal)
        let viewController = GoalDetailViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        navigation.pushViewController(viewController, animated: true, backClosure: isCompleted)
    }
}
