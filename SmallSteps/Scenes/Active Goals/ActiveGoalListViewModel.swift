//
//  ActiveGoalListViewModel.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/23/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

protocol ActiveGoalListViewModelInput {
    func takeAStep(at indexPath: IndexPath)
    func archiveGoal(at indexPath: IndexPath)
    func addGoal()
    func refreshGoals()
}

protocol ActiveGoalListViewModelOutput {
    var goalsCount: Int { get }
    func cellViewModel(at indexPath: IndexPath) -> ActiveGoalListCellViewModel
    func canTakeAStep(at indexPath: IndexPath) -> Bool
    var enterCreateGoalSecene: (() -> Void)? { get set }
}

protocol ActiveGoalListViewModel: ActiveGoalListViewModelInput, ActiveGoalListViewModelOutput { }
