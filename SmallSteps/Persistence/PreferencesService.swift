//
//  PreferencesService.swift
//  SmallSteps
//
//  Created by Stone Zhang on 3/4/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

protocol PreferencesService: AnyObject {
    var isTodayOnly: Bool { get set }
}
