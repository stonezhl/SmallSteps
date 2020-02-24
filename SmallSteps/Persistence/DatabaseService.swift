//
//  DatabaseService.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/23/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

protocol DatabaseService {
    var activeSteps: [Bool] { get set }
    func takeStep(at index: Int)
    func archiveStep(at index: Int)
    func addStep()
    var archivedSteps: [Bool] { get set }
    func restoreStep(at index: Int)
    func deleteStep(at index: Int)
    func fetchActiveGoals() throws -> [Goal]
    func archiveGoal(_ goal: Goal) throws
    func addGoal(_ goal: Goal) throws
    func fetchArchivedGoals() throws -> [Goal]
    func restoreGoal(_ goal: Goal) throws
    func deleteGoal(_ goal: Goal) throws
    func saveContext()
}
