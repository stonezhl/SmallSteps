//
//  DefaultActiveGoalListViewModel.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/23/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit

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
        self.dataCenter.activeGoals.addObserver(self, initialNotificationType: .none) { [weak self] goals in
            self?.isDataUpdated?()
        }
        try? self.dataCenter.fetchActiveGoals()
    }

    private func takeStep(at indexPath: IndexPath, isCreated: Bool) {
        let step = Step(uuid: UUID().uuidString, createdDate: Date())
        if isCreated {
            try? dataCenter.takeStep(goal: goals[indexPath.row], step: step)
        } else {
            try? dataCenter.deleteSteps(goal: goals[indexPath.row], on: today)
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

    func archiveOrDeleteGoal(at indexPath: IndexPath) {
        try? dataCenter.archiveOrDeleteGoal(goals[indexPath.row])
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
        return ActiveGoalListCellViewModel(goal: goal, hasStep: hasStep, date: today, indexPath: indexPath) { [weak self] isCreated in
            self?.takeStep(at: indexPath, isCreated: isCreated)
        }
    }

    func editActionImage(at indexPath: IndexPath) -> UIImage {
        if dataCenter.stepsCount(goal: goals[indexPath.row]) > 0 {
            return UIImage(systemName: "archivebox")!
        } else {
            return UIImage(systemName: "trash")!
        }
    }
}
