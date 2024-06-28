//
//  LKCGFLoat Ext.swift
//  LonginesKit
//
//  Created by liam on 24/6/24.
//

import UIKit

public class LKAppAppearance {
    public static var designerScreenWidth: CGFloat = 414.0
    public static var designerScreenHeight: CGFloat = 896.0
    
    public static var isAppStoreEnviroment: Bool {
#if targetEnvironment(simulator) || DEBUG
        return false
#else
        guard let url = Bundle.main.appStoreReceiptURL else {
            return true
        }
        if url.path.contains("sandboxReceipt") {
            return false
        }
        return true
#endif
    }
    
    public static var isTestFlightOrAppStoreEnviroment: Bool {
#if targetEnvironment(simulator) || DEBUG
        return false
#else
        guard let url = Bundle.main.appStoreReceiptURL else {
            return true
        }
        if url.path.contains("sandboxReceipt") {
            return true
        }
        return true
#endif
    }
}

// MARK: - Int
extension Int {
    public var scale: CGFloat {
        return CGFloat(self).scale
    }
    
    public var scaleX: CGFloat {
        return CGFloat(self).scaleX
    }
    
    public var scaleY: CGFloat {
        return CGFloat(self).scaleY
    }
}

// MARK: - CGFloat
extension CGFloat {
    
    public var scale: CGFloat {
        return scale(ratio: diagonalRatio)
    }
    
    public var scaleX: CGFloat {
        return scale(ratio: CGFloat.screenWidth / LKAppAppearance.designerScreenWidth)
    }
    
    public var scaleY: CGFloat {
        return scale(ratio: CGFloat.screenHeight / LKAppAppearance.designerScreenWidth)
    }
    
    public static var screenWidth: CGFloat {
        return UIApplication.keyWindow?.bounds.width ?? 0
    }
    
    public static var screenHeight: CGFloat {
        return UIApplication.keyWindow?.bounds.height ?? 0
    }
    
    func scale(ratio: CGFloat) -> CGFloat {
        return (self * ratio)
    }
    
    var diagonalRatio: CGFloat {
        let a = sqrt(pow(CGFloat.screenWidth, 2) + pow(CGFloat.screenHeight, 2))
        let b = sqrt(pow(LKAppAppearance.designerScreenWidth, 2) + pow(LKAppAppearance.designerScreenHeight, 2))
        return a / b
    }
}

// MARK: - UIApplication
extension UIApplication {
    
    public static func topVC(base: UIViewController? = nil) -> UIViewController? {
        let base = base ?? keyWindow?.rootViewController
        if let nav = base as? UINavigationController {
            return topVC(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topVC(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return topVC(base: presented)
        }
        return base
    }
    
    public static var hasNotch: Bool {
        return safeAreaInsets?.bottom != 0
    }
    
    public static  var hasBottomSlider: Bool {
        return hasNotch
    }
    
    public static var windowScene: UIWindowScene? {
        UIApplication.shared.connectedScenes.first as? UIWindowScene
    }
    
    public static var keyWindow: UIWindow? {
        guard let window = windowScene?.windows.first
        else {
            return nil
        }
        return window
    }
    
    public static var safeAreaInsets: UIEdgeInsets? {
        keyWindow?.safeAreaInsets ?? .zero
    }
}
