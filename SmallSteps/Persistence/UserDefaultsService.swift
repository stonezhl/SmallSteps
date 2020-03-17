//
//  UserDefaultsService.swift
//  SmallSteps
//
//  Created by Stone Zhang on 3/4/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

class UserDefaultsService: NSObject, PreferencesService {
    private let userDefaults = UserDefaults.standard

    var appAppearance: AppAppearance {
        return AppAppearance(rawValue: userDefaults.integer(forKey: "APP_APPEARANCE")) ?? .automatic
    }

    var isAppAppearanceChanged: ((AppAppearance) -> Void)?

    var isTodayOnly: Bool {
        get { userDefaults.bool(forKey: "IS_TODAY_ONLY") }
        set { userDefaults.set(newValue, forKey: "IS_TODAY_ONLY") }
    }

    override init() {
        super.init()
        userDefaults.register(defaults: ["IS_TODAY_ONLY": false])
        NotificationCenter.default.addObserver(self, selector: #selector(userDefaultsDidChange(notification:)), name: UserDefaults.didChangeNotification, object: nil)
    }

    @objc func userDefaultsDidChange(notification: NSNotification) {
        self.isAppAppearanceChanged?(self.appAppearance)
    }
}
