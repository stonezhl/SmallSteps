//
//  DefaultActiveGoalListViewModel.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/23/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

class DefaultActiveGoalListViewModel: ActiveGoalListViewModel {
    private let databaseService: DatabaseService
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
        let step = Step(uuid: UUID().uuidString, createdDate: Date())
        try? databaseService.takeStep(goal: goals[indexPath.row], step: step)
    }

    func archiveGoal(at indexPath: IndexPath) {
        let goal = goals.remove(at: indexPath.row)
        try? databaseService.archiveGoal(goal)
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
        let goal = goals[indexPath.row]
        let hasStep = databaseService.hasStep(goal: goal, on: Date())
        return ActiveGoalListCellViewModel(goal: goal, hasStep: hasStep)
    }

    func canTakeStep(at indexPath: IndexPath) -> Bool {
        let currentDate = Date()
        let goal = goals[indexPath.row]
        let hasStep = databaseService.hasStep(goal: goal, on: currentDate)
        return goal.isAvailable(date: currentDate) && !hasStep
    }
}
