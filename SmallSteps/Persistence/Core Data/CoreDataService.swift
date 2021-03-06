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
    }

    func saveContext() {
        stack.saveContext()
    }

    private func fetchGoalDBModel(uuid: String) throws -> GoalDBModel? {
        let request: NSFetchRequest<GoalDBModel> = GoalDBModel.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "uuid = %@", uuid)
        return try context.fetch(request).first
    }
}

extension CoreDataService {
    func fetchActiveGoals() throws -> [Goal] {
        let request: NSFetchRequest<GoalDBModel> = GoalDBModel.fetchRequest()
        request.predicate = NSPredicate(format: "statusValue = %d", GoalStatus.active.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)]
        do {
            return try context.fetch(request).map { $0.parseToGoal() }
        } catch {
            print("Fetching active goals failed: \(error)")
            throw DatabaseError.fetchingActiveGoalsFailed(error: error)
        }
    }

    func hasStep(goal: Goal, on date: Date) -> Bool {
        do {
            guard let goalDBModel = try fetchGoalDBModel(uuid: goal.uuid) else { return false }
            let startOfDay = date.startOfDay
            guard let endOfDay = date.endOfDay else { return false }
            let stepDBModels = goalDBModel.steps.filtered(using: NSPredicate(format: "createdDate >= %@ && createdDate <= %@", startOfDay as NSDate, endOfDay as NSDate))
            return !stepDBModels.isEmpty
        } catch {
            return false
        }
    }

    func takeStep(goal: Goal, step: Step) throws {
        do {
            guard let goalDBModel = try fetchGoalDBModel(uuid: goal.uuid) else {
                throw DatabaseError.goalNotFound(goal: goal)
            }
            let stepDBModel = StepDBModel(context: context)
            stepDBModel.parseFromStep(step)
            stepDBModel.goal = goalDBModel
            goalDBModel.updatedDate = step.createdDate
            try context.save()
        } catch {
            print("Taking step failed: \(error)")
            throw DatabaseError.takingStepFailed(error: error)
        }
    }

    func deleteSteps(goal: Goal, on date: Date) throws {
        do {
            guard let goalDBModel = try fetchGoalDBModel(uuid: goal.uuid) else {
                throw DatabaseError.goalNotFound(goal: goal)
            }
            let startOfDay = date.startOfDay
            guard let endOfDay = date.endOfDay else { return }
            let stepDBModels = goalDBModel.steps.filtered(using: NSPredicate(format: "createdDate >= %@ && createdDate <= %@", startOfDay as NSDate, endOfDay as NSDate))
            stepDBModels.forEach { context.delete($0 as! StepDBModel) }
            try context.save()
        } catch {
            print("Deleting steps failed: \(error)")
            throw DatabaseError.deletingStepsFailed(error: error)
        }
    }

    func stepsCount(goal: Goal) -> Int {
        do {
            guard let goalDBModel = try fetchGoalDBModel(uuid: goal.uuid) else { return 0 }
            return goalDBModel.steps.count
        } catch {
            return 0
        }
    }

    func archiveOrDeleteGoal(_ goal: Goal) throws {
        do {
            guard let goalDBModel = try fetchGoalDBModel(uuid: goal.uuid) else {
                throw DatabaseError.goalNotFound(goal: goal)
            }
            if goalDBModel.steps.count > 0 {
                goalDBModel.status = .archived
                goalDBModel.updatedDate = Date()
            } else {
                context.delete(goalDBModel)
            }
            try context.save()
        } catch {
            print("Archiving or deleting goal failed: \(error)")
            throw DatabaseError.archivingOrDeletingGoalFailed(error: error)
        }
    }
}

extension CoreDataService {
    func addGoal(_ goal: Goal) throws {
        let goalDBModel = GoalDBModel(context: context)
        goalDBModel.parseFromGoal(goal)
        do {
            try context.save()
        } catch {
            print("Adding goal failed: \(error)")
            throw DatabaseError.addingGoalFailed(error: error)
        }
    }
}

extension CoreDataService {
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

    func deleteGoal(_ goal: Goal) throws {
        do {
            guard let goalDBModel = try fetchGoalDBModel(uuid: goal.uuid) else { return }
            context.delete(goalDBModel)
            try context.save()
        } catch {
            print("Deleting goal failed: \(error)")
            throw DatabaseError.deletingGoalFailed(error: error)
        }
    }
}

extension CoreDataService {
    func fetchSteps(goal: Goal) throws -> [Step] {
        do {
            guard let goalDBModel = try fetchGoalDBModel(uuid: goal.uuid) else {
                throw DatabaseError.goalNotFound(goal: goal)
            }
            return goalDBModel.steps.compactMap { ($0 as? StepDBModel)?.parseToStep() }.sorted { $0.createdDate < $1.createdDate }
        } catch {
            print("Fetching steps failed: \(error)")
            throw DatabaseError.fetchingStepsFailed(error: error)
        }
    }
}
