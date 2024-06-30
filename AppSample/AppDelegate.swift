//
//  AppDelegate.swift
//  AppSample
//
//  Created by liam on 24/6/24.
//

import UIKit
import LonginesKit
import LonginesFirebase
import LonginesQonversion

@main
class AppDelegate: LKPluggableApplicationDelegate {
    
    override var services: [any LKPluggableApplicationDelegateService] {
        internalServices
    }
    
    private var internalServices = [any LKPluggableApplicationDelegateService]()
    
    
    override init() {
        super.init()
        
        let firebasePlugin = LKFirebaseConfigPlugin.init(testDeviceIDs: [])
        let remoteConfigPlugin = LKRemoteConfigPlugin(firebasePlugin: firebasePlugin)
        
        internalServices = [
            firebasePlugin,
            remoteConfigPlugin,
            LKRemoteConfigPlugin.init(firebasePlugin: firebasePlugin),
            LKUserPropertyPlugin.init(remoteConfigPlugin: remoteConfigPlugin),
            LKAnalyticPlugin.init(firebasePlugin: firebasePlugin),
            LKIAPPlugin.init(projectKey: "m1woJHYltNnj4JARHt8JJWA0ejZiel_x"),
            LKBannerAdsPlugin()
        ]
    }
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let `super` = super.application(application, didFinishLaunchingWithOptions: launchOptions)
        LKAppAppearance.designerScreenWidth = 1000
        LKAppAppearance.designerScreenHeight = 1000
        
        let vc = HomeViewController.init()
        let nav = vc.embedNavigation
        nav.setNavigationBarHidden(true, animated: false)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
        return `super`
    }
}

