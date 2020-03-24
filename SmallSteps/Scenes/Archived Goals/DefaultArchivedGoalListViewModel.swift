//
//  DefaultArchivedGoalListViewModel.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/24/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

class DefaultArchivedGoalListViewModel: ArchivedGoalListViewModel {
    private let dataCenter: DataCenter
    var enterGoalDetailScene: ((Goal) -> Void)?
    var didExitScene: (() -> Void)?
    private var goals: [Goal] = []

    init(dataCenter: DataCenter) {
        self.dataCenter = dataCenter
        goals = (try? dataCenter.fetchArchivedGoals()) ?? []
    }
}

extension DefaultArchivedGoalListViewModel {
    func deleteGoal(at indexPath: IndexPath) {
        let goal = goals.remove(at: indexPath.row)
        try? dataCenter.deleteGoal(goal)
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
