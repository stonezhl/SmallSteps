//
//  DefaultArchivedGoalListViewModel.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/24/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

class DefaultArchivedGoalListViewModel: ArchivedGoalListViewModel {
    private var databaseService: DatabaseService
    var enterGoalDetailScene: ((Goal) -> Void)?

    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
}

extension DefaultArchivedGoalListViewModel {
    func restoreGoal(at indexPath: IndexPath) {
        databaseService.restoreGoal(at: indexPath.row)
    }

    func deleteGoal(at indexPath: IndexPath) {
        databaseService.deleteGoal(at: indexPath.row)
    }

    func showDetail(at indexPath: IndexPath) {
        enterGoalDetailScene?(databaseService.archivedGoals[indexPath.row])
    }
}

extension DefaultArchivedGoalListViewModel {
    var goalsCount: Int {
        return databaseService.archivedGoals.count
    }

    func cellViewModel(at indexPath: IndexPath) -> ArchivedGoalListCellViewModel {
        return ArchivedGoalListCellViewModel(goal: databaseService.archivedGoals[indexPath.row])
    }
}
