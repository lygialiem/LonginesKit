//
//  Dictionary Ext.swift
//  LonginesKit
//
//  Created by liam on 24/6/24.
//

import Foundation

extension Dictionary {
    
   public func merge(params: [Key: Value]) -> [Key: Value] {
        var result: [Key: Value] = self
        params.forEach { key, value in
            result.updateValue(value, forKey: key)
        }
        return result
    }
}
