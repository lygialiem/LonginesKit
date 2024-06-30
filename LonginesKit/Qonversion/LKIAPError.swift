//
//  LKIAPError.swift
//  LonginesKit
//
//  Created by liam on 30/6/24.
//

import Foundation

public enum LKIAPError: Error {
    case emptyPermissions
    case fetchProductFailed
    case restoreError
    case purchaseError
    case qonversionUnknownError
    case didMadePurchaseButActiveFalse
}
