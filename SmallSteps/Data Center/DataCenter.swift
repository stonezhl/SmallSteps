//
//  DataCenter.swift
//  SmallSteps
//
//  Created by Stone Zhang on 3/4/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

protocol DataCenter {
    // prefrences
    var appAppearance: Observable<AppAppearance> { get }
    // app
    var today: Observable<Date> { get }
    func saveData()
    // active goals
    var isTodayOnly: Observable<Bool> { get }
    var activeGoals: Observable<[Goal]> { get }
    func fetchActiveGoals() throws
    func hasStep(goal: Goal, on date: Date) -> Bool
    func takeStep(goal: Goal, step: Step) throws
    func deleteSteps(goal: Goal, on date: Date) throws
    func stepsCount(goal: Goal) -> Int
    func archiveOrDeleteGoal(_ goal: Goal) throws
    // create goal
    func addGoal(_ goal: Goal) throws
    // archived goals
    func fetchArchivedGoals() throws -> [Goal]
    func deleteGoal(_ goal: Goal) throws
    // goal detail
    func fetchSteps(goal: Goal) throws -> [Step]
}

