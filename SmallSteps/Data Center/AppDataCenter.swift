//
//  AppDataCenter.swift
//  SmallSteps
//
//  Created by Stone Zhang on 3/4/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

class AppDataCenter: DataCenter {
    private let databaseService: DatabaseService = CoreDataService(name: "SmallSteps")
    private let preferencesService: PreferencesService = UserDefaultsService()

    let today: Observable<Date> = Observable(Date())
    let isTodayOnly: Observable<Bool>
    let activeGoals: Observable<[Goal]> = Observable([])

    init() {
        isTodayOnly = Observable(preferencesService.isTodayOnly)
        isTodayOnly.addObserver(self) { [weak self] isTodayOnly in
            self?.preferencesService.isTodayOnly = isTodayOnly
        }
        NotificationCenter.default.addObserver(self, selector: #selector(dayChanged(notification:)), name: .NSCalendarDayChanged, object: nil)
    }

    func saveData() {
        databaseService.saveContext()
    }

    @objc func dayChanged(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.today.value = Date()
            try? self?.fetchActiveGoals()
        }
    }
}

extension AppDataCenter {
    func fetchActiveGoals() throws {
        if isTodayOnly.value {
            try fetchTodayActiveGoals()
        } else {
            try fetchAllActiveGoals()
        }
    }

    private func fetchTodayActiveGoals() throws {
        do {
            activeGoals.value = try databaseService.fetchActiveGoals().filter { $0.isAvailable(date: today.value) }
        } catch {
            activeGoals.value = []
            throw error
        }
    }

    private func fetchAllActiveGoals() throws {
        do {
            activeGoals.value = try databaseService.fetchActiveGoals().sorted {
                let isFirstOnDate = $0.isAvailable(date: today.value)
                let isSecondOnDate = $1.isAvailable(date: today.value)
                if isFirstOnDate != isSecondOnDate {
                    return isFirstOnDate
                } else {
                    return $0.updatedDate > $1.updatedDate
                }
            }
        } catch {
            activeGoals.value = []
            throw error
        }
    }

    func hasStep(goal: Goal, on date: Date) -> Bool {
        return databaseService.hasStep(goal: goal, on: date)
    }

    func takeStep(goal: Goal, step: Step) throws {
        try databaseService.takeStep(goal: goal, step: step)
    }

    func archiveGoal(_ goal: Goal) throws {
        try databaseService.archiveGoal(goal)
        activeGoals.valueWithoutNotification = activeGoals.value.filter { $0 != goal }
    }
}

extension AppDataCenter {
    func addGoal(_ goal: Goal) throws {
        try databaseService.addGoal(goal)
        try fetchActiveGoals()
    }
}

extension AppDataCenter {
    func fetchArchivedGoals() throws -> [Goal] {
        return try databaseService.fetchArchivedGoals()
    }

    func restoreGoal(_ goal: Goal) throws {
        try databaseService.restoreGoal(goal)
        try fetchActiveGoals()
    }

    func deleteGoal(_ goal: Goal) throws {
        try databaseService.deleteGoal(goal)
    }
}

extension AppDataCenter {
    func fetchSteps(goal: Goal) throws -> [Step] {
        try databaseService.fetchSteps(goal: goal)
    }
}
