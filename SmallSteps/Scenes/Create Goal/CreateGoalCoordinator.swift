//
//  CreateGoalCoordinator.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/23/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit

class CreateGoalCoordinator: BaseCoordinator {
    private let navigation: Navigation
    private let databaseService: DatabaseService

    init(navigation: Navigation, databaseService: DatabaseService) {
        self.navigation = navigation
        self.databaseService = databaseService
    }

    override func start() {
        let viewModel = DefaultCreateGoalViewModel(databaseService: databaseService)
        let viewController = CreateGoalViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        viewModel.didExitScene = { [weak self] in
            self?.isCompleted?()
        }
        navigation.present(navigationController, animated: true)
    }
}
