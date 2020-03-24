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
    let isLeftFoot: Bool?
    let isSelected: Bool
    let takeStep: ((Bool) -> Void)?

    init(goal: Goal, hasStep: Bool, date: Date, indexPath: IndexPath, takeStep: ((Bool) -> Void)? = nil) {
        title = goal.title
        frequency = goal.frequencyDescription
        if goal.isAvailable(date: date) {
            isLeftFoot = (indexPath.row % 2 == 0)
            isSelected = hasStep
        } else {
            isLeftFoot = nil
            isSelected = false
        }
        self.takeStep = takeStep
    }
}
