//
//  DefaultActiveGoalListViewModel.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/23/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

class DefaultActiveGoalListViewModel: ActiveGoalListViewModel {
    private let dataCenter: DataCenter
    var isDataUpdated: (() -> Void)?
    var enterCreateGoalScene: (() -> Void)?
    var enterArchivedGoalsScene: (() -> Void)?
    var enterGoalDetailScene: ((Goal) -> Void)?

    private var goals: [Goal] {
        return dataCenter.activeGoals.value
    }

    private var today: Date {
        return dataCenter.today.value
    }

    init(dataCenter: DataCenter) {
        self.dataCenter = dataCenter
        self.dataCenter.activeGoals.addObserver(self) { [weak self] goals in
            self?.isDataUpdated?()
        }
    }

    deinit {
        dataCenter.activeGoals.removeObserver(self)
    }
}

extension DefaultActiveGoalListViewModel {
    func fetchActiveGoals(isTodayOnly: Bool) throws {
        dataCenter.isTodayOnly.value = isTodayOnly
        try? dataCenter.fetchActiveGoals()
    }

    func takeStep(at indexPath: IndexPath) {
        let step = Step(uuid: UUID().uuidString, createdDate: Date())
        try? dataCenter.takeStep(goal: goals[indexPath.row], step: step)
    }

    func archiveGoal(at indexPath: IndexPath) {
        try? dataCenter.archiveGoal(goals[indexPath.row])
    }

    func addGoal() {
        enterCreateGoalScene?()
    }

    func showArchived() {
        enterArchivedGoalsScene?()
    }

    func showDetail(at indexPath: IndexPath) {
        enterGoalDetailScene?(goals[indexPath.row])
    }
}

extension DefaultActiveGoalListViewModel {
    var isTodayOnly: Bool {
        return dataCenter.isTodayOnly.value
    }

    var goalsCount: Int {
        return goals.count
    }

    func cellViewModel(at indexPath: IndexPath) -> ActiveGoalListCellViewModel {
        let goal = goals[indexPath.row]
        let hasStep = dataCenter.hasStep(goal: goal, on: today)
        return ActiveGoalListCellViewModel(goal: goal, hasStep: hasStep, date: today, indexPath: indexPath)
    }

    func canTakeStep(at indexPath: IndexPath) -> Bool {
        let goal = goals[indexPath.row]
        let hasStep = dataCenter.hasStep(goal: goal, on: today)
        return goal.isAvailable(date: today) && !hasStep
    }
}
