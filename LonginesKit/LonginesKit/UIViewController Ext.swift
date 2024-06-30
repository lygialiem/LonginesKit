//
//  UIViewController Ext.swift
//  LonginesKit
//
//  Created by liam on 24/6/24.
//

import UIKit

extension UIViewController {
    
    public var className: String {
        let productName = (Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String) ?? Bundle.main.appName
        let pageNameValue = NSStringFromClass(self.classForCoder)
        let stringToReplace = productName + "."
        let result = pageNameValue
            .replacingOccurrences(of: stringToReplace, with: "")
        return result
    }
    
    public var embedNavigation: UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
    public func removeFromParentViewController() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
        didMove(toParent: nil)
    }
    
}
