//
//  Decodable Ext.swift
//  LonginesKit
//
//  Created by liam on 16/7/24.
//

import Foundation

public extension Encodable {
    func encoded() -> String? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

public extension String {
    func decoded<T: Decodable>(_ type: T.Type) -> T? {
        let decoder = JSONDecoder()
        guard let data = self.data(using: .utf8) else { return nil }
        do {
            let object = try decoder.decode(T.self, from: data)
            return object
        } catch {
            loggingPrint(error)
            return nil
        }
    }
}

public extension Dictionary {
    var stringify: String {
        guard let data = try? JSONSerialization.data(withJSONObject: self),
            let string = String(data: data, encoding: .utf8)
        else {
            return ""
        }
        return string
    }
}
