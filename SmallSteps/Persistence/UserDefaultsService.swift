//
//  UserDefaultsService.swift
//  SmallSteps
//
//  Created by Stone Zhang on 3/4/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

class UserDefaultsService: PreferencesService {
    private let userDefaults = UserDefaults.standard

    var isTodayOnly: Bool {
        get {
            userDefaults.bool(forKey: "isTodayOnly")
        }
        set {
            userDefaults.set(newValue, forKey: "isTodayOnly")
        }
    }

    init() {
        userDefaults.register(defaults: ["isTodayOnly": false])
    }
}
