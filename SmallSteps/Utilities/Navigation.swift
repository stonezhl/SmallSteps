//
//  Navigation.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/9/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit

typealias NavigationBackClosure = () -> Void

protocol Navigation {
    func pushViewController(_ viewController: UIViewController, animated: Bool, backClosure: NavigationBackClosure?)
    func popViewController(animated: Bool) -> UIViewController?
    func popToRootViewController(animated: Bool) -> [UIViewController]?
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool)
}
