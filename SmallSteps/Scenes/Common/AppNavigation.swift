//
//  AppNavigation.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/9/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit

class AppNavigation: NSObject, Navigation {
    let navigationController: UINavigationController
    private var backClosures: [String: NavigationBackClosure] = [:]

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
    }

    func pushViewController(_ viewController: UIViewController, animated: Bool, backClosure: NavigationBackClosure?) {
        if let closure = backClosure {
            backClosures[viewController.description] = closure
        }
        navigationController.pushViewController(viewController, animated: animated)
    }

    func popViewController(animated: Bool) -> UIViewController? {
        return navigationController.popViewController(animated: animated)
    }

    func popToRootViewController(animated: Bool) -> [UIViewController]? {
        return navigationController.popToRootViewController(animated: animated)
    }

    private func executeBackClosure(_ viewController: UIViewController) {
        guard let closure = backClosures.removeValue(forKey: viewController.description) else { return }
        closure()
    }
}

extension AppNavigation: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let previousController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(previousController) else {
                return
        }
        executeBackClosure(previousController)
    }
}
