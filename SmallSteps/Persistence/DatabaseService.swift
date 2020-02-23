//
//  DatabaseService.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/23/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

protocol DatabaseService {
    var newGoal: Goal? { get set }
    func saveContext()
}
