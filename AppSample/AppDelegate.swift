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
        
        let bannerAdPlugin = LKBannerAdsPlugin.init(config: .testConfig)
        let interstitialAdPlugin = LKInterstitialAdsPlugin.init(config: .testConfig)
        let rewardedAdPlugin = LKRewardedAdPlugin.init(config: .testConfig)
        let nativeAdPlugin = LKNativeAdPlugin.init(config: .testConfig)
        let appOpenAdPlugin = LKAppOpenAdsPlugin.init(config: .testConfig)
        
        internalServices = [
            LKFirebaseConfigPlugin.init(testDeviceIDs: []),
            LKRemoteConfigPlugin.init(),
            LKUserPropertyPlugin.init(),
            LKAnalyticPlugin.init(),
            LKIAPPlugin.init(projectKey: "m1woJHYltNnj4JARHt8JJWA0ejZiel_x"),
            LKAdvertisementPlugin(ads: [bannerAdPlugin, interstitialAdPlugin, rewardedAdPlugin, nativeAdPlugin, appOpenAdPlugin]),
            bannerAdPlugin,
            interstitialAdPlugin,
            rewardedAdPlugin,
            nativeAdPlugin,
            appOpenAdPlugin,
        ]
    }
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let `super` = super.application(application, didFinishLaunchingWithOptions: launchOptions)
        LKAppAppearance.designerScreenWidth = 430
        LKAppAppearance.designerScreenHeight = 932
        
        let vc = LKExampleViewController.init()
        let nav = vc.embedNavigation
        nav.setNavigationBarHidden(true, animated: false)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
        return `super`
    }
}
