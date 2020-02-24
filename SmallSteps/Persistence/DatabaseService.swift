//
//  DatabaseService.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/23/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

protocol DatabaseService {
    var activeGoals: [Goal] { get set }
    var activeSteps: [Bool] { get set }
    var archivedGoals: [Goal] { get set }
    var archivedSteps: [Bool] { get set }
    func takeStep(at index: Int)
    func archiveGoal(at index: Int)
    func addGoal(_ goal: Goal)
    func restoreGoal(at index: Int)
    func deleteGoal(at index: Int)
    func saveContext()
}
