//
//  Common.swift
//  CovidCases
//
//  Created by Imthath M on 04/04/20.
//  Copyright © 2020 Imthath. All rights reserved.
//

import Foundation

@propertyWrapper
public struct SDDefault<T> {
    let key: String
    let defaultValue: T

    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}

public struct Defaults {
    @SDDefault("updatedTime", defaultValue: nil)
    static var updatedTime: Date? 
}
