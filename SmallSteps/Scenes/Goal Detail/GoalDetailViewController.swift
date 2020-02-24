//
//  GoalDetailViewController.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/24/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit

class GoalDetailViewController: UIViewController {
    let viewModel: GoalDetailViewModel

    init(viewModel: GoalDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("`init(coder:)` has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.goal.title
        view.backgroundColor = UIColor.yellow
        navigationItem.largeTitleDisplayMode = .never
    }
}
