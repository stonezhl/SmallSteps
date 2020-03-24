//
//  DatabaseError.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/24/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

enum DatabaseError: Error {
    case goalNotFound(goal: Goal)
    case fetchingActiveGoalsFailed(error: Error)
    case takingStepFailed(error: Error)
    case deletingStepsFailed(error: Error)
    case archivingOrDeletingGoalFailed(error: Error)
    case addingGoalFailed(error: Error)
    case fetchingArchivedGoalsFailed(error: Error)
    case deletingGoalFailed(error: Error)
    case fetchingStepsFailed(error: Error)
}
