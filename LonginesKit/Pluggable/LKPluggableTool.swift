//
//  LKPluggableTool.swift
//
//  Created by aiden on 27/10/2023.
//

import UIKit

public struct LKPluggableTool {
    
    public static var appDelegate: UIApplicationDelegate? { UIApplication.shared.delegate }
    
    public static func queryAppDelegate<T>(for service: T.Type) -> T? {
        return (UIApplication.shared.delegate! as? LKPluggableApplicationDelegate)?.queryService()
    }
}
