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
    private let dataCenter: DataCenter

    init(navigation: Navigation, dataCenter: DataCenter) {
        self.navigation = navigation
        self.dataCenter = dataCenter
    }

    override func start() {
        let viewModel = DefaultCreateGoalViewModel(dataCenter: dataCenter)
        let viewController = CreateGoalViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.tintColor = .label
        viewModel.didExitScene = { [weak self] in
            self?.isCompleted?()
        }
        navigation.present(navigationController, animated: true)
    }
}
