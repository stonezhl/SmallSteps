//
//  CoreDataService.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/23/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

class CoreDataService: DatabaseService {
    private let stack: CoreDataStack

    var activeGoals: [Goal] = [
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

    var activeSteps: [Bool] = [false, false, false, false, false]

    var archivedGoals: [Goal] = []

    var archivedSteps: [Bool] = []

    init(name: String) {
        stack = CoreDataStack(name: name)
    }

    func takeStep(at index: Int) {
        activeSteps[index] = true
    }

    func archiveGoal(at index: Int) {
        let goal = activeGoals.remove(at: index)
        let step = activeSteps.remove(at: index)
        archivedGoals.insert(goal, at: 0)
        archivedSteps.insert(step, at: 0)
    }

    func addGoal(_ goal: Goal) {
        activeGoals.insert(goal, at: 0)
        activeSteps.insert(false, at: 0)
    }

    func restoreGoal(at index: Int) {
        let goal = archivedGoals.remove(at: index)
        let step = archivedSteps.remove(at: index)
        activeGoals.insert(goal, at: 0)
        activeSteps.insert(step, at: 0)
    }

    func deleteGoal(at index: Int) {
        archivedGoals.remove(at: index)
        archivedSteps.remove(at: index)
    }

    func saveContext() {
        stack.saveContext()
    }
}
