//
//  GoalDBModel+CoreDataClass.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/24/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import CoreData

@objc(GoalDBModel)
public class GoalDBModel: NSManagedObject {
    var frequency: GoalFrequency {
        get { GoalFrequency(rawValue: frequencyValue) }
        set { frequencyValue = newValue.rawValue }
    }

    var status: GoalStatus {
        get { GoalStatus(rawValue: statusValue) ?? .active }
        set { statusValue = newValue.rawValue }
    }
}

extension GoalDBModel {
    func parseToGoal() -> Goal {
        return Goal(uuid: uuid,
                    title: title,
                    frequency: frequency,
                    status: status,
                    createdDate: createdDate,
                    updatedDate: updatedDate)
    }

    func parseFromGoal(_ goal: Goal) {
        uuid = goal.uuid
        title = goal.title
        frequency = goal.frequency
        status = goal.status
        createdDate = goal.createdDate
        updatedDate = goal.updatedDate
    }
}
