//
//  ActiveGoalListCellViewModel.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/23/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit

struct ActiveGoalListCellViewModel {
    let title: String
    let frequency: String
    let markColor: UIColor?
    let isEnabled: Bool

    init(goal: Goal, hasStep: Bool) {
        title = goal.title
        frequency = goal.frequencyDescription
        isEnabled = goal.isAvailable(date: Date())
        if isEnabled {
            markColor = hasStep ? .systemOrange : .systemGray
        } else {
            markColor = .clear
        }
    }
}
