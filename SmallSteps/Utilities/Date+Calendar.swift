//
//  Date+Calendar.swift
//  SmallSteps
//
//  Created by Stone Zhang on 3/13/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

extension Date {
    var calendar: Calendar {
        return Calendar.current
    }

    var year: Int {
        return calendar.component(.year, from: self)
    }

    var month: Int {
        return calendar.component(.month, from: self)
    }

    var weekday: Int {
        return calendar.component(.weekday, from: self)
    }

    var startOfDay: Date {
        return calendar.startOfDay(for: self)
    }

    var endOfDay: Date? {
        return calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self)
    }

    var nextDay: Date? {
        return calendar.date(byAdding: .day, value: 1, to: self)
    }

    var monthInterval: DateInterval? {
        return calendar.dateInterval(of: .month, for: self)
    }

    var isInToday: Bool {
        return calendar.isDateInToday(self)
    }

    var isInWeekend: Bool {
        return calendar.isDateInWeekend(self)
    }

    func inSameDayAs(_ date: Date) -> Bool {
        return calendar.isDate(self, inSameDayAs: date)
    }
}
