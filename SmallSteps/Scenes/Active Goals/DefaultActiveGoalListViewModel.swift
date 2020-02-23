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

    private var steps: [Bool] = [false, false, false, false, false]

    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }

    func takeAStep(at indexPath: IndexPath) {
        steps[indexPath.row] = true
    }

    func archiveGoal(at indexPath: IndexPath) {
        goals.remove(at: indexPath.row)
        steps.remove(at: indexPath.row)
    }

    var goalsCount: Int {
        return goals.count
    }

    func cellViewModel(at indexPath: IndexPath) -> ActiveGoalListCellViewModel {
        return ActiveGoalListCellViewModel(goal: goals[indexPath.row], hasAStep: steps[indexPath.row])
    }

    func canTakeAStep(at indexPath: IndexPath) -> Bool {
        return goals[indexPath.row].isAvailable(date: Date()) && steps[indexPath.row] == false
    }
}
