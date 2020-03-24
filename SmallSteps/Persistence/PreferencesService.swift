//
//  PreferencesService.swift
//  SmallSteps
//
//  Created by Stone Zhang on 3/4/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

enum AppAppearance: Int {
    case system = 0
    case light = 1
    case dark = 2
}

protocol PreferencesService: AnyObject {
    var appAppearance: AppAppearance { get }
    var isAppAppearanceChanged: ((AppAppearance) -> Void)? { get set }
    var isTodayOnly: Bool { get set }
}
