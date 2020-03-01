//
//  ArchivedGoalListViewModel.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/24/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

protocol ArchivedGoalListViewModelInput {
    func fetchArchivedGoals()
    func restoreGoal(at indexPath: IndexPath)
    func deleteGoal(at indexPath: IndexPath)
    func showDetail(at indexPath: IndexPath)
}

protocol ArchivedGoalListViewModelOutput {
    var goalsCount: Int { get }
    func cellViewModel(at indexPath: IndexPath) -> ArchivedGoalListCellViewModel
    var enterGoalDetailScene: ((Goal) -> Void)? { get set }
    var didExitScene: (() -> Void)? { get set }
}

protocol ArchivedGoalListViewModel: ArchivedGoalListViewModelInput, ArchivedGoalListViewModelOutput { }
