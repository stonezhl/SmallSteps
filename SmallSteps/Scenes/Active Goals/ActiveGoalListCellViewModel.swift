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

    init(goal: Goal, hasStep: Bool, date: Date) {
        title = goal.title
        frequency = goal.frequencyDescription
        if goal.isAvailable(date: date) {
            markColor = hasStep ? .systemOrange : .systemFill
        } else {
            markColor = .clear
        }
    }
}
