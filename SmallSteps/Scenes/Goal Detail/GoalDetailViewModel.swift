//
//  GoalDetailViewModel.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/24/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

protocol GoalDetailViewModelInput: AnyObject {
    var todayIndex: IndexPath? { get set }
    func fetchSteps()
}

protocol GoalDetailViewModelOutput {
    var today: Date { get }
    var startDate: Date { get }
    var endDate: Date { get }
    func hasStep(on date: Date) -> Bool?
    func title(on date: Date) -> String
}

protocol GoalDetailViewModel: GoalDetailViewModelInput, GoalDetailViewModelOutput { }
