//
//  ActiveGoalListViewModel.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/23/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit

protocol ActiveGoalListViewModelInput {
    func fetchActiveGoals(isTodayOnly: Bool) throws
    func archiveOrDeleteGoal(at indexPath: IndexPath)
    func addGoal()
    func showArchived()
    func showDetail(at indexPath: IndexPath)
}

protocol ActiveGoalListViewModelOutput: AnyObject {
    var isTodayOnly: Bool { get }
    var goalsCount: Int { get }
    func cellViewModel(at indexPath: IndexPath) -> ActiveGoalListCellViewModel
    func editActionImage(at indexPath: IndexPath) -> UIImage
    var isDataUpdated: (() -> Void)? { get set }
    var enterCreateGoalScene: (() -> Void)? { get set }
    var enterArchivedGoalsScene: (() -> Void)? { get set }
    var enterGoalDetailScene: ((Goal) -> Void)? { get set }
}

protocol ActiveGoalListViewModel: ActiveGoalListViewModelInput, ActiveGoalListViewModelOutput { }
