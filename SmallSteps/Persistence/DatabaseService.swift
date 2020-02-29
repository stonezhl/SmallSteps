//
//  DatabaseService.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/23/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

protocol DatabaseService {
    func saveContext()
    // active goals
    func fetchActiveGoals(on date: Date) throws -> [Goal]
    func fetchActiveGoals() throws -> [Goal]
    func hasStep(goal: Goal, on date: Date) -> Bool
    func takeStep(goal: Goal, step: Step) throws
    func archiveGoal(_ goal: Goal) throws
    // create goal
    func addGoal(_ goal: Goal) throws
    // archived goals
    func fetchArchivedGoals() throws -> [Goal]
    func restoreGoal(_ goal: Goal) throws
    func deleteGoal(_ goal: Goal) throws
    // goal detail
    func fetchSteps(goal: Goal) throws -> [Step]
}
