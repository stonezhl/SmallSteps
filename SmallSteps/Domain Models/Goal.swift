//
//  Goal.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/23/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

struct GoalFrequency: OptionSet {
    let rawValue: Int16

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

enum GoalStatus: Int16 {
    case active = 0
    case archived = 1
}

struct Goal: Equatable {
    let uuid: String
    let title: String
    let frequency: GoalFrequency
    let status: GoalStatus
    let createdDate: Date
    let updatedDate: Date

    static func == (lhs: Goal, rhs: Goal) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

extension Goal {
    var frequencyDescription: String {
        if frequency == .everyday {
            return NSLocalizedString("Every day", comment: "Goal's frequency")
        } else if frequency == .weekdays {
            return NSLocalizedString("Every weekday", comment: "Goal's frequency")
        } else if frequency == .weekends {
            return NSLocalizedString("Every weekend", comment: "Goal's frequency")
        } else if frequency == .everyMonday {
            return NSLocalizedString("Every Monday", comment: "Goal's frequency")
        } else if frequency == .everyTuesday {
            return NSLocalizedString("Every Tuesday", comment: "Goal's frequency")
        } else if frequency == .everyWednesday {
            return NSLocalizedString("Every Wednesday", comment: "Goal's frequency")
        } else if frequency == .everyThursday {
            return NSLocalizedString("Every Thursday", comment: "Goal's frequency")
        } else if frequency == .everyFriday {
            return NSLocalizedString("Every Friday", comment: "Goal's frequency")
        } else if frequency == .everySaturday {
            return NSLocalizedString("Every Saturday", comment: "Goal's frequency")
        } else if frequency == .everySunday {
            return NSLocalizedString("Every Sunday", comment: "Goal's frequency")
        } else {
            var description: String = ""
            let weekdaySymbols = Calendar.current.shortWeekdaySymbols
            if frequency.contains(.everyMonday) {
                description += "\(weekdaySymbols[1]) "
            }
            if frequency.contains(.everyTuesday) {
                description += "\(weekdaySymbols[2]) "
            }
            if frequency.contains(.everyWednesday) {
                description += "\(weekdaySymbols[3]) "
            }
            if frequency.contains(.everyThursday) {
                description += "\(weekdaySymbols[4]) "
            }
            if frequency.contains(.everyFriday) {
                description += "\(weekdaySymbols[5]) "
            }
            if frequency.contains(.everySaturday) {
                description += "\(weekdaySymbols[6]) "
            }
            if frequency.contains(.everySunday) {
                description += "\(weekdaySymbols[0]) "
            }
            description = String(description.dropLast())
            return description
        }
    }

    func isAvailable(date: Date) -> Bool {
        let weekday = date.weekday
        switch weekday {
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

    func totalStepsCount(startDate: Date, endDate: Date) -> Int {
        let startDate = max(startDate, createdDate)
        let endDate = status == .active ? endDate : min(endDate, updatedDate)
        var count = 0
        var startOfDay = startDate.startOfDay
        while startOfDay <= endDate {
            if isAvailable(date: startOfDay) {
                count += 1
            }
            guard let nextStartOfDay = startOfDay.nextDay else { break }
            startOfDay = nextStartOfDay
        }
        return count
    }

    var archivedDate: Date? {
        return status == .archived ? updatedDate : nil
    }
}
