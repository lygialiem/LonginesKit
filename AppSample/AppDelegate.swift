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
        
        let bannerAdPlugin = LKBannerAdsPlugin.init(config: .default)
        let interstitialAdPlugin = LKInterstitialAdsPlugin.init(config: .default)
        let rewardedAdPlugin = LKRewardedAdPlugin.init(config: .default)
        let nativeAdPlugin = LKNativeAdPlugin.init(config: .default)
        
        internalServices = [
            LKFirebaseConfigPlugin.init(testDeviceIDs: []),
            LKRemoteConfigPlugin.init(),
            LKUserPropertyPlugin.init(),
            LKAnalyticPlugin.init(),
            LKIAPPlugin.init(projectKey: "m1woJHYltNnj4JARHt8JJWA0ejZiel_x"),
            LKAdvertisementPlugin(ads: [bannerAdPlugin, interstitialAdPlugin, rewardedAdPlugin, nativeAdPlugin]),
            bannerAdPlugin,
            interstitialAdPlugin,
            rewardedAdPlugin,
            nativeAdPlugin,
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



extension LKAdvertisements {
    static let `default` = LKAdvertisements.init(bannerAdID: "ca-app-pub-3940256099942544/2435281174",
                                                 interstitialAdID: "ca-app-pub-3940256099942544/4411468910",
                                                 rewardedAdID: "ca-app-pub-3940256099942544/1712485313",
                                                 nativeAdID: "ca-app-pub-3940256099942544/3986624511")
}
