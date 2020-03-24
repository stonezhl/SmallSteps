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
    private let dataCenter: DataCenter
    private let goal: Goal

    init(navigation: Navigation, dataCenter: DataCenter, goal: Goal) {
        self.navigation = navigation
        self.dataCenter = dataCenter
        self.goal = goal
    }

    override func start() {
        let viewModel = DefaultGoalDetailViewModel(dataCenter: dataCenter, goal: goal)
        let viewController = GoalDetailViewController(viewModel: viewModel)
//        viewController.hidesBottomBarWhenPushed = true
        navigation.pushViewController(viewController, animated: true, backClosure: isCompleted)
    }
}
