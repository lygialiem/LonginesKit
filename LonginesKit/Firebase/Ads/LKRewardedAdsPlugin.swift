//
//  LKRewardedAdsPlugin.swift
//  LonginesKit
//
//  Created by liam on 30/6/24.
//

import UIKit
import GoogleMobileAds
import LonginesKit

public class LKRewardedAdPlugin: NSObject, LKPluggableApplicationDelegateService {
    
   public enum Status {
        case noAdToShow
        case onDismiss
        case didReward

    }
    
    static let instance = LKRewardedAdPlugin.init()
    
    private var rewardedAd: GADRewardedAd?
    private var onDismiss: LKValueAction<Status>?
    private var didReward = false
    private let id: String
    
    public init(id: String = "ca-app-pub-3940256099942544/1712485313") {
        self.id = id
        super.init()
    }
}

public extension LKRewardedAdPlugin {
    
    func loadRewardedAd() {
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
