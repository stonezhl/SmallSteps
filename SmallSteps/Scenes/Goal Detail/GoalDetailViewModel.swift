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
    var today: Date { get }
    var createdDate: Date { get }
    var archivedDate: Date? { get }
    var startDate: Date { get }
    var endDate: Date { get }
    func hasStep(on date: Date) -> Bool?
    var monthStepsCounts: [MonthStepsCount] { get }
}

protocol GoalDetailViewModel: GoalDetailViewModelInput, GoalDetailViewModelOutput { }
