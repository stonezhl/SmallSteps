//
//  DefaultGoalDetailViewModel.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/24/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

class DefaultGoalDetailViewModel: GoalDetailViewModel {
    private let databaseService: DatabaseService
    let goal: Goal

    init(databaseService: DatabaseService, goal: Goal) {
        self.databaseService = databaseService
        self.goal = goal
    }
}
