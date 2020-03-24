//
//  Observable.swift
//  SmallSteps
//
//  Created by Stone Zhang on 3/3/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation

typealias BindingClosure<T> = (T) -> Void

enum InitialNotificationType {
    case none
    case sync
    case async
}

class Observable<T> {
    struct Observer<T> {
        weak var observer: AnyObject?
        let bindingClosure: BindingClosure<T>
    }

    private var observers: [Observer<T>] = []

    private var internalValue: T

    var value: T {
        get { internalValue }
        set {
            internalValue = newValue
            notifyObservers()
        }
    }

    var valueWithoutNotification: T {
        get { internalValue }
        set { internalValue = newValue }
    }

    init(_ value: T) {
        internalValue = value
        notifyObservers()
    }

    func addObserver(_ observer: AnyObject, initialNotificationType: InitialNotificationType, bindingClosure: @escaping BindingClosure<T>) {
        let observer = Observer<T>(observer: observer, bindingClosure: bindingClosure)
        observers.append(observer)
        switch initialNotificationType {
        case .none: break
        case .sync:
            bindingClosure(self.value)
        case .async:
            DispatchQueue.main.async {
                bindingClosure(self.value)
            }
        }
    }

    func removeObserver(_ observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }

    func notifyObservers() {
        observers.forEach { observer in
            DispatchQueue.main.async {
                observer.bindingClosure(self.value)
            }
        }
    }
}
