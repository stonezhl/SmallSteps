//
//  DefaultCreateGoalViewModel.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/23/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

class DefaultCreateGoalViewModel: CreateGoalViewModel {
    private let dataCenter: DataCenter
    var didExitScene: (() -> Void)?

    let frequencyTitles = [
        NSLocalizedString("Every Sunday", comment: "Goal's frequency"),
        NSLocalizedString("Every Monday", comment: "Goal's frequency"),
        NSLocalizedString("Every Tuesday", comment: "Goal's frequency"),
        NSLocalizedString("Every Wednesday", comment: "Goal's frequency"),
        NSLocalizedString("Every Thursday", comment: "Goal's frequency"),
        NSLocalizedString("Every Friday", comment: "Goal's frequency"),
        NSLocalizedString("Every Saturday", comment: "Goal's frequency"),
    ]

    init(dataCenter: DataCenter) {
        self.dataCenter = dataCenter
    }

    func saveGoal(title: String, selectedIndexPaths: [IndexPath]) {
        var frequency: GoalFrequency = []
        selectedIndexPaths.forEach { indexPath in
            switch indexPath.row {
            case 0: frequency.insert(.everySunday)
            case 1: frequency.insert(.everyMonday)
            case 2: frequency.insert(.everyTuesday)
            case 3: frequency.insert(.everyWednesday)
            case 4: frequency.insert(.everyThursday)
            case 5: frequency.insert(.everyFriday)
            case 6: frequency.insert(.everySaturday)
            default: break
            }
        }
        let currentDate = Date()
        let goal = Goal(uuid: UUID().uuidString,
                        title: title,
                        frequency: frequency,
                        status: .active,
                        createdDate: currentDate,
                        updatedDate: currentDate)
        try? dataCenter.addGoal(goal)
    }
}
