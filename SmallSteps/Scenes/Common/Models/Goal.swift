//
//  Goal.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/23/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

struct GoalFrequency: OptionSet {
    let rawValue: Int

    static let everySunday = GoalFrequency(rawValue: 1 << 0)
    static let everyMonday = GoalFrequency(rawValue: 1 << 1)
    static let everyTuesday = GoalFrequency(rawValue: 1 << 2)
    static let everyWednesday = GoalFrequency(rawValue: 1 << 3)
    static let everyThursday = GoalFrequency(rawValue: 1 << 4)
    static let everyFriday = GoalFrequency(rawValue: 1 << 5)
    static let everySaturday = GoalFrequency(rawValue: 1 << 6)
    static let weekdays: GoalFrequency = [.everyMonday, .everyTuesday, .everyWednesday, .everyThursday, .everyFriday]
    static let weekends: GoalFrequency = [.everySaturday, .everySunday]
    static let everyday: GoalFrequency = [.weekdays, .weekends]
}

enum GoalStatus: Int {
    case active = 0
    case archived = 1
}

struct Goal {
    let uuid: String
    let title: String
    let frequency: GoalFrequency
    let status: GoalStatus
    let createdDate: Date
    let updatedDate: Date

    var frequencyDescription: String {
        if frequency == .everyday {
            return "Every day"
        } else if frequency == .weekdays {
            return "Every weekday"
        } else if frequency == .weekends {
            return "Every weekend"
        } else if frequency == .everyMonday {
            return "Every Monday"
        } else if frequency == .everyTuesday {
            return "Every Tuesday"
        } else if frequency == .everyWednesday {
            return "Every Wednesday"
        } else if frequency == .everyThursday {
            return "Every Thursday"
        } else if frequency == .everyFriday {
            return "Every Friday"
        } else if frequency == .everySaturday {
            return "Every Saturday"
        } else if frequency == .everySunday {
            return "Every Sunday"
        } else {
            var description: String = "Every "
            if frequency.contains(.everyMonday) {
                description += "Mon, "
            }
            if frequency.contains(.everyTuesday) {
                description += "Tue, "
            }
            if frequency.contains(.everyWednesday) {
                description += "Wed, "
            }
            if frequency.contains(.everyThursday) {
                description += "Thu, "
            }
            if frequency.contains(.everyFriday) {
                description += "Fri, "
            }
            if frequency.contains(.everySaturday) {
                description += "Sat, "
            }
            if frequency.contains(.everySunday) {
                description += "Sun, "
            }
            description = String(description.dropLast(2))
            return description
        }
    }

    func isAvailable(date: Date) -> Bool {
        let day = Calendar.current.component(.weekday, from: date)
        switch day {
        case 1: return frequency.contains(.everySunday)
        case 2: return frequency.contains(.everyMonday)
        case 3: return frequency.contains(.everyTuesday)
        case 4: return frequency.contains(.everyWednesday)
        case 5: return frequency.contains(.everyThursday)
        case 6: return frequency.contains(.everyFriday)
        case 7: return frequency.contains(.everySaturday)
        default: return false
        }
    }
}
