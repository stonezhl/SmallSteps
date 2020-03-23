//
//  DatabaseError.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/24/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

enum DatabaseError: Error {
    case fetchingActiveGoalsFailed(error: Error)
    case takingStepFailed(error: Error)
    case archivingGoalFailed(error: Error)
    case addingGoalFailed(error: Error)
    case fetchingArchivedGoalsFailed(error: Error)
    case restoringGoalFailed(error: Error)
    case deletingGoalFailed(error: Error)
    case goalNotFound(goal: Goal)
}
