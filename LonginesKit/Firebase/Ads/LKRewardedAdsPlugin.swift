//
//  LKRewardedAdsPlugin.swift
//  LonginesKit
//
//  Created by liam on 30/6/24.
//

import UIKit
import GoogleMobileAds
import LonginesKit
import Combine

public class LKRewardedAdPlugin: NSObject, LKPluggableApplicationDelegateService, LKAdPluggable {
    
    public var config: LKAdvertisements
    
    public required init(config: LKAdvertisements) {
        self.config = config
        
        super.init()
    }
    
    public func updateConfig(_ config: LKAdvertisements) {
        self.config = config
    }
    
    
    public enum Status {
        case noAdToShow
        case onDismiss
        case didReward
        
    }
    
    private var rewardedAd: GADRewardedAd?
    private var onDismiss: LKValueAction<Status>?
    private var didReward = false
    private var cancellables = Set<AnyCancellable>.init()
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        if let advertisementPlugin = LKPluggableTool.queryAppDelegate(for: LKAdvertisementPlugin.self) {
            advertisementPlugin.advertisementsPublisher
                .compactMap{$0}
                .sink { [weak self] config in
                    self?.config = config
                }
                .store(in: &cancellables)
        }
        return true
    }
}

public extension LKRewardedAdPlugin {
    
    func loadRewardedAd() {
        guard let id = config.rewardedAdID, !id.isEmpty else { return }
        
        
        guard rewardedAd == nil else { return }
        
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: id,
                           request: request,
                           completionHandler: { [weak self] ad, error in
            guard let ad else {
                print("Failed to load rewarded ad with error: \(error?.localizedDescription as Any)")
                return
            }
            ad.fullScreenContentDelegate = self
            self?.rewardedAd = ad
        })
    }
    
    func presentRewardedAd(at root: UIViewController, onDismiss: @escaping LKValueAction<Status>) {
        guard let rewardedAd else {
            loadRewardedAd()
            onDismiss(.noAdToShow)
            return
        }
        self.didReward = false
        self.onDismiss = onDismiss
        
        rewardedAd.present(fromRootViewController: root) { [weak self] in
            self?.didReward = true
        }
    }
}

extension LKRewardedAdPlugin: GADFullScreenContentDelegate {
    
    public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
        didReward = false
    }
    
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        rewardedAd = nil
        loadRewardedAd()
        
        onDismiss?(didReward ? .didReward : .onDismiss)
        didReward = false
    }
}
