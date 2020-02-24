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
    private var goals: [Goal] = []

    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
}

extension DefaultArchivedGoalListViewModel {
    func fetchArchivedGoals() {
        goals = (try? databaseService.fetchArchivedGoals()) ?? []
    }

    func restoreGoal(at indexPath: IndexPath) {
        let goal = goals.remove(at: indexPath.row)
        try? databaseService.restoreGoal(goal)
        databaseService.restoreStep(at: indexPath.row)
    }

    func deleteGoal(at indexPath: IndexPath) {
        let goal = goals.remove(at: indexPath.row)
        try? databaseService.deleteGoal(goal)
        databaseService.deleteStep(at: indexPath.row)
    }

    func showDetail(at indexPath: IndexPath) {
        enterGoalDetailScene?(goals[indexPath.row])
    }
}

extension DefaultArchivedGoalListViewModel {
    var goalsCount: Int {
        return goals.count
    }

    func cellViewModel(at indexPath: IndexPath) -> ArchivedGoalListCellViewModel {
        return ArchivedGoalListCellViewModel(goal: goals[indexPath.row])
    }
}
