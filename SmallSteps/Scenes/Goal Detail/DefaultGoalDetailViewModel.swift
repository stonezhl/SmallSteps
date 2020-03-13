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
        return goal.createdDate.startOfDay
    }

    var endDate: Date {
        return goal.status == .active ? today : goal.updatedDate
    }

    func hasStep(on date: Date) -> Bool? {
        guard goal.isAvailable(date: date) else { return nil }
        let startOfDay = date.startOfDay
        if let archivedDate = goal.archivedDate,  startOfDay > archivedDate { return nil }
        guard let endOfDay = date.endOfDay else { return nil }
        if endOfDay < goal.createdDate { return nil }
        let dateSteps = steps.filter { $0.createdDate >= startOfDay && $0.createdDate <= endOfDay }
        return !dateSteps.isEmpty
    }

    var monthStepsCounts: [MonthStepsCount] {
        var counts = [MonthStepsCount]()
        guard let monthInterval = startDate.monthInterval else { return [] }
        var startOfMonth = monthInterval.start
        var endOfMonth = monthInterval.end
        while startOfMonth <= endDate {
            let year = startOfMonth.year
            let month = startOfMonth.month
            let totalCount = goal.totalStepsCount(startDate: startOfMonth, endDate: min(endOfMonth, endDate))
            let completedCount = steps.filter { $0.createdDate >= startOfMonth && $0.createdDate <= endOfMonth }.count
            counts.append(MonthStepsCount(year: year, month: month, total: totalCount, completed: completedCount))
            guard let nextDay = endOfMonth.nextDay, let monthInterval = nextDay.monthInterval else { break }
            startOfMonth = monthInterval.start
            endOfMonth = monthInterval.end
        }
        return counts
    }
}
