//
//  ArchivedGoalListCellViewModel.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/24/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

struct ArchivedGoalListCellViewModel {
    let title: String
    let frequency: String

    init(goal: Goal) {
        title = goal.title
        frequency = goal.frequencyDescription
    }
}
