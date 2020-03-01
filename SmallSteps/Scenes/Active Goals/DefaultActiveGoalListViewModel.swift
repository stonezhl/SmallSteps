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
    var isDataUpdated: (() -> Void)?
    var enterCreateGoalScene: (() -> Void)?
    var enterArchivedGoalsScene: (() -> Void)?
    var enterGoalDetailScene: ((Goal) -> Void)?
    private var goals: [Goal] = []

    var today: Date = Date()

    var isTodayOnly: Bool = false

    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
        NotificationCenter.default.addObserver(self, selector: #selector(dayChanged(notification:)), name: .NSCalendarDayChanged, object: nil)
    }

    @objc func dayChanged(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.today = Date()
            try? self?.fetchActiveGoals()
        }
    }
}

extension DefaultActiveGoalListViewModel {
    func fetchActiveGoals() throws {
        try fetchActiveGoals(isTodayOnly: isTodayOnly)
    }

    func fetchActiveGoals(isTodayOnly: Bool) throws {
        if isTodayOnly {
            goals = try databaseService.fetchActiveGoals(on: today)
        } else {
            goals = try databaseService.fetchActiveGoals()
        }
        self.isTodayOnly = isTodayOnly
        isDataUpdated?()
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

    func showArchived() {
        enterArchivedGoalsScene?()
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
        let hasStep = databaseService.hasStep(goal: goal, on: today)
        return ActiveGoalListCellViewModel(goal: goal, hasStep: hasStep, date: today)
    }

    func canTakeStep(at indexPath: IndexPath) -> Bool {
        let goal = goals[indexPath.row]
        let hasStep = databaseService.hasStep(goal: goal, on: today)
        return goal.isAvailable(date: today) && !hasStep
    }
}
