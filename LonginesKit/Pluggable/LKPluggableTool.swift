//
//  LKPluggableTool.swift
//
//  Created by aiden on 27/10/2023.
//

import UIKit

struct LKPluggableTool {
    
    static var appDelegate: UIApplicationDelegate? { UIApplication.shared.delegate }
    
    static func queryAppDelegate<T>(for service: T.Type) -> T? {
        return (UIApplication.shared.delegate! as? LKPluggableApplicationDelegate)?.queryService()
    }
}
