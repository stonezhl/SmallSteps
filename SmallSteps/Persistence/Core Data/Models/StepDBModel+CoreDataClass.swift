//
//  StepDBModel+CoreDataClass.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/24/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import CoreData

@objc(StepDBModel)
public class StepDBModel: NSManagedObject {

}

extension StepDBModel {
    func parseToStep() -> Step {
        return Step(uuid: uuid, createdDate: createdDate)
    }

    func parseFromStep(_ step: Step) {
        uuid = step.uuid
        createdDate = step.createdDate
    }
}
