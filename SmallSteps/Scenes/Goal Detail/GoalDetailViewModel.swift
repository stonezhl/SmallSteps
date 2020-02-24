//
//  GoalDetailViewModel.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/24/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

protocol GoalDetailViewModelInput { }

protocol GoalDetailViewModelOutput {
    var goal: Goal { get }
}

protocol GoalDetailViewModel: GoalDetailViewModelInput, GoalDetailViewModelOutput { }
