//
//  Json Ext.swift
//  LonginesKit
//
//  Created by liam on 24/6/24.
//

import Foundation

extension Data {
    
    public func decoded<T: Decodable>(_ type: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(T.self, from: self)
            return object
        } catch {
            loggingPrint(error)
            return nil
        }
    }
}
