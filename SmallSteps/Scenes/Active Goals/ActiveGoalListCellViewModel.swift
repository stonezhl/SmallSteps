//
//  ActiveGoalListCellViewModel.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/23/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit

struct ActiveGoalListCellViewModel {
    let title: String
    let frequency: String
    let isLeftFoot: Bool
    let footImage: UIImage?
    let markColor: UIColor?

    init(goal: Goal, hasStep: Bool, date: Date, indexPath: IndexPath) {
        title = goal.title
        frequency = goal.frequencyDescription
        if goal.isAvailable(date: date) {
            isLeftFoot = (indexPath.row % 2 == 0)
            let imageName = isLeftFoot ? "left_foot" : "right_foot"
            let image = UIImage(named: imageName)
            footImage = image?.withRenderingMode(.alwaysTemplate)
            markColor = hasStep ? .systemOrange : .tertiaryLabel
        } else {
            isLeftFoot = false
            footImage = nil
            markColor = nil
        }
    }
}
