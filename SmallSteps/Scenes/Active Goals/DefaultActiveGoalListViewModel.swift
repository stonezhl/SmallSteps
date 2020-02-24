//
//  DefaultActiveGoalListViewModel.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/23/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

class DefaultActiveGoalListViewModel: ActiveGoalListViewModel {
    private var databaseService: DatabaseService
    var enterCreateGoalSecene: (() -> Void)?

    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
}

extension DefaultActiveGoalListViewModel {
    func takeStep(at indexPath: IndexPath) {
        databaseService.takeStep(at: indexPath.row)
    }

    func archiveGoal(at indexPath: IndexPath) {
        databaseService.archiveGoal(at: indexPath.row)
    }

    func addGoal() {
        enterCreateGoalSecene?()
    }
}

extension DefaultActiveGoalListViewModel {
    var goalsCount: Int {
        return databaseService.activeGoals.count
    }

    func cellViewModel(at indexPath: IndexPath) -> ActiveGoalListCellViewModel {
        return ActiveGoalListCellViewModel(goal: databaseService.activeGoals[indexPath.row], hasAStep: databaseService.activeSteps[indexPath.row])
    }

    func canTakeStep(at indexPath: IndexPath) -> Bool {
        return databaseService.activeGoals[indexPath.row].isAvailable(date: Date()) && databaseService.activeSteps[indexPath.row] == false
    }
}
