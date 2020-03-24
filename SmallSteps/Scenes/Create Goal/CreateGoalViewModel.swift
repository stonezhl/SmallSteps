//
//  CreateGoalViewModel.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/23/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

protocol CreateGoalViewModelInput {
    func saveGoal(title: String, selectedIndexPaths: [IndexPath])
}

protocol CreateGoalViewModelOutput {
    var frequencyTitles: [String] { get }
    var didExitScene: (() -> Void)? { get set }
}

protocol CreateGoalViewModel: CreateGoalViewModelInput, CreateGoalViewModelOutput { }
