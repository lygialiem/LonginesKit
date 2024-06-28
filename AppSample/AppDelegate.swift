//
//  AppDelegate.swift
//  AppSample
//
//  Created by liam on 24/6/24.
//

import UIKit
import LonginesKit

@main
class AppDelegate: LKPluggableApplicationDelegate {
    
    override var services: [any LKPluggableApplicationDelegateService] {
        internalServices
    }
    
    private var internalServices = [any LKPluggableApplicationDelegateService]()
    
    
    override init() {
        super.init()
        
        internalServices = [
            
        ]
       
    }
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LKAppAppearance.designerScreenWidth = 1000
        LKAppAppearance.designerScreenHeight = 1000
        
        let vc = HomeViewController.init()
        let nav = vc.embedNavigation
        nav.setNavigationBarHidden(true, animated: false)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

