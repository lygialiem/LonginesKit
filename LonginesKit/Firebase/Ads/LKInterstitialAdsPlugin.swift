//
//  LKInterstitialAdsPlugin.swift
//  LonginesKit
//
//  Created by liam on 30/6/24.
//

import Foundation
import Combine
import GoogleMobileAds
import LonginesKit

public struct LKInterstitialAdConfig: LKAdConfigurable {
    public var id: String
}

public class LKInterstitialAdsPlugin: NSObject, LKPluggableApplicationDelegateService, LKAdPluggable {
    
    private var interstitialAd: GADInterstitialAd?
    private var onDismiss: LKVoidAction?
    private let numberOfRetry = 3
    private var retryCounting = 0
    private let loadInteralInSeconds: TimeInterval = 60
    private var cancellables = Set<AnyCancellable>.init()
    public var config: LKAdvertisements
    
    required public init(config: LKAdvertisements) {
        self.config = config
        super.init()
    }
    
    public func updateConfig(_ config: LKAdvertisements) {
        self.config = config
    }
}

public extension LKInterstitialAdsPlugin {
    
    func loadInterstitial() {
        
        guard let id = config.interstitialAdID, !id.isEmpty else { return }
        
        let request = GADRequest()
        
        GADInterstitialAd.load(withAdUnitID: id,
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load Interstitial Ad with error: \(error.localizedDescription)")
                reloadInterstitial()
                return
            }
            interstitialAd = ad
            interstitialAd?.fullScreenContentDelegate = self
            retryCounting = 0
        })
    }
    
   func presentInterstitial(from viewController: UIViewController, onDismiss: LKVoidAction?) {
        if let interstitialAd {
            interstitialAd.present(fromRootViewController: viewController)
            self.onDismiss = onDismiss
            return
        }
       
        loadInterstitial()
        onDismiss?()
    }
}

public extension LKInterstitialAdsPlugin {
    
   private func reloadInterstitial() {
        guard interstitialAd == nil else { return }
        retryCounting += 1
        guard retryCounting <= numberOfRetry else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + loadInteralInSeconds) {
            self.loadInterstitial()
        }
    }
    
    
}

extension LKInterstitialAdsPlugin: GADFullScreenContentDelegate {
    /// Tells the delegate that the ad failed to present full screen content.
    public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content:", error.localizedDescription)
    }
    
    /// Tells the delegate that the ad will present full screen content.
    public func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        interstitialAd = nil
        loadInterstitial()
        DispatchQueue.main.async {
            self.onDismiss?()
            self.onDismiss = nil
        }
        
    }
}
