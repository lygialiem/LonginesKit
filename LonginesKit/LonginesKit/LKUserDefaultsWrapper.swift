//
//  UserDefaultsWrapper.swift
//  LonginesKit
//
//  Created by liam on 24/6/24.
//

import Foundation

@propertyWrapper
public struct LKUserDefaultWrapper<T: Codable> {
    let defaultValue: T
    let key: String
    
    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: T {
        get {
            if let value = UserDefaults.standard.get(T.self, key: key) {
                return value
            } else {
                return defaultValue
            }
        }
        set {
            UserDefaults.standard.set(T.self, value: newValue, key: key)
        }
    }
}

public extension UserDefaults {
    func get<T: Codable>(_ type: T.Type, key: String) -> T? {
        guard let valueAsString = string(forKey: key) else {
            return nil
        }
        guard let valueAsData = valueAsString.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(T.self, from: valueAsData)
    }
    
    func set<T: Codable>(_ type: T.Type, value: T, key: String) {
        guard let valueAsData = try? JSONEncoder().encode(value) else { return }
        let valueAsString = String(data: valueAsData, encoding: .utf8)
        set(valueAsString, forKey: key)
        synchronize()
    }
}
