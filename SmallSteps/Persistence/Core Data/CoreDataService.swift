//
//  CoreDataService.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/23/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import CoreData

class CoreDataService: DatabaseService {
    private let stack: CoreDataStack

    private var context: NSManagedObjectContext {
        return stack.persistentContainer.viewContext
    }

    init(name: String) {
        stack = CoreDataStack(name: name)
        let activeGoalsCount = (try? fetchActiveGoals().count) ?? 0
        let archivedGoalsCount = (try? fetchArchivedGoals().count) ?? 0
        activeSteps = Array(repeating: false, count: activeGoalsCount)
        archivedSteps = Array(repeating: false, count: archivedGoalsCount)
    }

    var activeSteps: [Bool] = []

    func takeStep(at index: Int) {
        activeSteps[index] = true
    }

    func archiveStep(at index: Int) {
        let step = activeSteps.remove(at: index)
        archivedSteps.insert(step, at: 0)
    }

    func addStep() {
        activeSteps.insert(false, at: 0)
    }

    var archivedSteps: [Bool] = []

    func restoreStep(at index: Int) {
        let step = archivedSteps.remove(at: index)
        activeSteps.insert(step, at: 0)
    }

    func deleteStep(at index: Int) {
        archivedSteps.remove(at: index)
    }

    func fetchActiveGoals() throws -> [Goal] {
        let request: NSFetchRequest<GoalDBModel> = GoalDBModel.fetchRequest()
        request.predicate = NSPredicate(format: "statusValue = %d", GoalStatus.active.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: "updatedDate", ascending: false)]
        do {
            return try context.fetch(request).map { $0.parseToGoal() }
        } catch {
            print("Fetching active goals failed: \(error)")
            throw DatabaseError.fetchingActiveGoalsFailed(error: error)
        }
    }

    func archiveGoal(_ goal: Goal) throws {
        let request: NSFetchRequest<GoalDBModel> = GoalDBModel.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "uuid = %@", goal.uuid)
        do {
            guard let dbModel = try context.fetch(request).first else { return }
            dbModel.status = .archived
            try context.save()
        } catch {
            print("Archiving goal failed: \(error)")
            throw DatabaseError.archivingGoalFailed(error: error)
        }
    }

    func addGoal(_ goal: Goal) throws {
        let dbModel = GoalDBModel(context: context)
        dbModel.parseFromGoal(goal)
        do {
            try context.save()
        } catch {
            print("Adding goal failed: \(error)")
            throw DatabaseError.addingGoalFailed(error: error)
        }
    }

    func fetchArchivedGoals() throws -> [Goal] {
        let request: NSFetchRequest<GoalDBModel> = GoalDBModel.fetchRequest()
        request.predicate = NSPredicate(format: "statusValue = %d", GoalStatus.archived.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: "updatedDate", ascending: false)]
        do {
            return try context.fetch(request).map { $0.parseToGoal() }
        } catch {
            print("Fetching archived goals failed: \(error)")
            throw DatabaseError.fetchingArchivedGoalsFailed(error: error)
        }
    }

    func restoreGoal(_ goal: Goal) throws {
        let request: NSFetchRequest<GoalDBModel> = GoalDBModel.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "uuid = %@", goal.uuid)
        do {
            guard let dbModel = try context.fetch(request).first else { return }
            dbModel.status = .active
            try context.save()
        } catch {
            print("Restoring goal failed: \(error)")
            throw DatabaseError.restoringGoalFailed(error: error)
        }
    }

    func deleteGoal(_ goal: Goal) throws {
        let request: NSFetchRequest<GoalDBModel> = GoalDBModel.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "uuid = %@", goal.uuid)
        do {
            guard let dbModel = try context.fetch(request).first else { return }
            context.delete(dbModel)
        } catch {
            print("Deleting goal failed: \(error)")
            throw DatabaseError.deletingGoalFailed(error: error)
        }
    }

    func saveContext() {
        stack.saveContext()
    }
}
