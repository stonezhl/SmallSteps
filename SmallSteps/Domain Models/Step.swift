//
//  Step.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/24/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

struct Step: Equatable {
    let uuid: String
    let createdDate: Date

    static func == (lhs: Step, rhs: Step) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
