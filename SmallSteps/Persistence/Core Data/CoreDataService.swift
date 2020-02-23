//
//  CoreDataService.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/23/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

class CoreDataService: DatabaseService {
    private let stack: CoreDataStack

    init(name: String) {
        stack = CoreDataStack(name: name)
    }

    func saveContext() {
        stack.saveContext()
    }
}
