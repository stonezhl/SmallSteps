//
//  DefaultGoalDetailViewModel.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/24/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

class DefaultGoalDetailViewModel: GoalDetailViewModel {
    private let dataCenter: DataCenter
    private let goal: Goal
    private let steps: [Step]

    init(dataCenter: DataCenter, goal: Goal) {
        self.dataCenter = dataCenter
        self.goal = goal
        steps = (try? dataCenter.fetchSteps(goal: goal)) ?? []
    }
}

extension DefaultGoalDetailViewModel {
    var today: Date {
        return dataCenter.today.value
    }

    var archivedDate: Date? {
        return goal.archivedDate
    }

    var startDate: Date {
        return goal.createdDate
    }

    var endDate: Date {
        return goal.status == .active ? today : goal.updatedDate
    }

    func hasStep(on date: Date) -> Bool? {
        guard goal.isAvailable(date: date) else { return nil }
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        if let archivedDate = goal.archivedDate,  startDate > archivedDate { return nil }
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else { return nil }
        if endDate < goal.createdDate { return nil }
        let dateSteps = steps.filter { $0.createdDate >= startDate && $0.createdDate <= endDate }
        return !dateSteps.isEmpty
    }

    var monthStepsCounts: [MonthStepsCount] {
        var counts = [MonthStepsCount]()
        let calendar = Calendar.current
        guard let interval = calendar.dateInterval(of: .month, for: startDate) else { return [] }
        var startOfMonth = interval.start
        var endOfMonth = interval.end
        while startOfMonth <= endDate {
            let year = calendar.component(.year, from: startOfMonth)
            let month = calendar.component(.month, from: startOfMonth)
            let totalCount = goal.totalStepsCount(startDate: startOfMonth, endDate: min(endOfMonth, endDate))
            let completedCount = steps.filter { $0.createdDate >= startOfMonth && $0.createdDate <= endOfMonth }.count
            counts.append(MonthStepsCount(year: year, month: month, total: totalCount, completed: completedCount))
            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: endOfMonth),
                let interval = calendar.dateInterval(of: .month, for: nextDay) else {
                    break
            }
            startOfMonth = interval.start
            endOfMonth = interval.end
        }
        return counts
    }
}
