//
//  GoalDBModel+CoreDataProperties.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/24/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import CoreData

extension GoalDBModel {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GoalDBModel> {
        return NSFetchRequest<GoalDBModel>(entityName: "GoalDBModel")
    }

    @NSManaged public var uuid: String
    @NSManaged public var title: String
    @NSManaged public var frequencyValue: Int16
    @NSManaged public var statusValue: Int16
    @NSManaged public var createdDate: Date
    @NSManaged public var updatedDate: Date
    @NSManaged public var steps: NSSet
}

// MARK: Generated accessors for steps
extension GoalDBModel {
    @objc(addStepsObject:)
    @NSManaged public func addToSteps(_ value: StepDBModel)

    @objc(removeStepsObject:)
    @NSManaged public func removeFromSteps(_ value: StepDBModel)

    @objc(addSteps:)
    @NSManaged public func addToSteps(_ values: NSSet)

    @objc(removeSteps:)
    @NSManaged public func removeFromSteps(_ values: NSSet)
}
