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
    var enterCreateGoalScene: (() -> Void)?
    var enterGoalDetailScene: ((Goal) -> Void)?
    private var goals: [Goal] = []

    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
}

extension DefaultActiveGoalListViewModel {
    func fetchActiveGoals() {
        goals = (try? databaseService.fetchActiveGoals()) ?? []
    }

    func takeStep(at indexPath: IndexPath) {
        databaseService.takeStep(at: indexPath.row)
    }

    func archiveGoal(at indexPath: IndexPath) {
        let goal = goals.remove(at: indexPath.row)
        try? databaseService.archiveGoal(goal)
        databaseService.archiveStep(at: indexPath.row)
    }

    func addGoal() {
        enterCreateGoalScene?()
    }

    func showDetail(at indexPath: IndexPath) {
        enterGoalDetailScene?(goals[indexPath.row])
    }
}

extension DefaultActiveGoalListViewModel {
    var goalsCount: Int {
        return goals.count
    }

    func cellViewModel(at indexPath: IndexPath) -> ActiveGoalListCellViewModel {
        return ActiveGoalListCellViewModel(goal: goals[indexPath.row], hasStep: databaseService.activeSteps[indexPath.row])
    }

    func canTakeStep(at indexPath: IndexPath) -> Bool {
        return goals[indexPath.row].isAvailable(date: Date()) && databaseService.activeSteps[indexPath.row] == false
    }
}
