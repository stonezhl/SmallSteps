//
//  StepDBModel+CoreDataProperties.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/24/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import CoreData

extension StepDBModel {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<StepDBModel> {
        return NSFetchRequest<StepDBModel>(entityName: "StepDBModel")
    }

    @NSManaged public var uuid: String
    @NSManaged public var createdDate: Date
    @NSManaged public var goal: GoalDBModel
}
