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

    private var goals: [Goal] = [
        Goal(uuid: "1",
             title: "Everyday",
             frequency: .everyday,
             status: .active,
             createdDate: Date(),
             updatedDate: Date()),
        Goal(uuid: "2",
             title: "Weekdays",
             frequency: .weekdays,
             status: .active,
             createdDate: Date(),
             updatedDate: Date()),
        Goal(uuid: "3",
             title: "Weekends",
             frequency: .weekends,
             status: .active,
             createdDate: Date(),
             updatedDate: Date()),
        Goal(uuid: "4",
             title: "Today",
             frequency: .everySunday,
             status: .active,
             createdDate: Date(),
             updatedDate: Date()),
        Goal(uuid: "5",
             title: "Except today",
             frequency: [.everyMonday, .everyTuesday, .everyWednesday, .everyThursday, .everyFriday, .everySaturday],
             status: .active,
             createdDate: Date(),
             updatedDate: Date()),
    ]

    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
}

extension DefaultArchivedGoalListViewModel {
    func restoreGoal(at indexPath: IndexPath) {
        goals.remove(at: indexPath.row)
    }

    func deleteGoal(at indexPath: IndexPath) {
        goals.remove(at: indexPath.row)
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
