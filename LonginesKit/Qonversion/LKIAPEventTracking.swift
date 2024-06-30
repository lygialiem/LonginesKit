//
//  LKIAPEventTracking.swift
//  LonginesKit
//
//  Created by liam on 30/6/24.
//

import Foundation

public enum LKIAPEventTracking: String {
    case subscribe_weeklyfreetrial
    case subscribe_monthly
    case subscribe_yearly
    case purchase_lifetime
    
    func track(params: [String: Any] = [:]) {
        self.rawValue.track(params: params)
    }
}
