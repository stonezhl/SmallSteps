//
//  DefaultGoalDetailViewModel.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/24/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

class DefaultGoalDetailViewModel: GoalDetailViewModel {
    private let databaseService: DatabaseService
    private let goal: Goal
    private var steps: [Step] = []

    lazy var today: Date = {
        return Date()
    }()

    var todayIndex: IndexPath?

    init(databaseService: DatabaseService, goal: Goal) {
        self.databaseService = databaseService
        self.goal = goal
    }
}

extension DefaultGoalDetailViewModel {
    func fetchSteps() {
        steps = (try? databaseService.fetchSteps(goal: goal)) ?? []
    }
}

extension DefaultGoalDetailViewModel {
    var startDate: Date {
        return goal.createdDate
    }

    var endDate: Date {
        return today
    }

    func hasStep(on date: Date) -> Bool? {
        guard goal.isAvailable(date: date) else { return nil }
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else { return nil }
        let dateSteps = steps.filter { $0.createdDate >= startDate && $0.createdDate <= endDate }
        return !dateSteps.isEmpty
    }

    func title(on date: Date) -> String {
        return String(Calendar.current.component(.year, from: date))
    }
}
