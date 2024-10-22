//
//  LKAppOpenAdsPlugin.swift
//  LonginesKit
//
//  Created by liam on 22/10/24.
//

import UIKit
import LonginesKit
import GoogleMobileAds
import Combine


public class LKAppOpenAdsPlugin: NSObject, LKPluggableApplicationDelegateService, LKAdPluggable {
    
    public var config: LKAdvertisements
    
    private var onDimiss: LKVoidAction?
    
    public func updateConfig(_ config: LKAdvertisements) {
        self.config = config
    }
    
    public required init(config: LKAdvertisements) {
        self.config = config
        
        super.init()
    }
    
    private var appOpenAd: GADAppOpenAd?
    private var isLoadingAd = false
    private var isShowingAd = false
    
    private func loadAd() async {
        
        guard let id = config.appOpenAdID, !id.isEmpty else {
            return
        }
        
        // Do not load ad if there is an unused ad or one is already loading.
        if isLoadingAd || isAdAvailable() {
            return
        }
        isLoadingAd = true
        
        do {
            appOpenAd = try await GADAppOpenAd.load(
                withAdUnitID: id, request: GADRequest())
            appOpenAd?.fullScreenContentDelegate = self
        } catch {
            print("App open ad failed to load with error: \(error.localizedDescription)")
        }
        isLoadingAd = false
    }
    
   public func present(from root: UIViewController? = nil, onDismiss: LKVoidAction? = nil) {
        // If the app open ad is already showing, do not show the ad again.
        guard !isShowingAd else { return }
        
        
        self.onDimiss = onDismiss
        // If the app open ad is not available yet but is supposed to show, load
        // a new ad.
        if !isAdAvailable() {
            Task {
                await loadAd()
            }
            return
        }
        
        if let ad = appOpenAd {
            isShowingAd = true
            ad.present(fromRootViewController: nil)
        }
    }
    
    private func isAdAvailable() -> Bool {
        // Check if ad exists and can be shown.
        return appOpenAd != nil
    }
}

extension LKAppOpenAdsPlugin: GADFullScreenContentDelegate {
    
   public  func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("App open ad will be presented.")
    }
    
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        appOpenAd = nil
        isShowingAd = false
        // Reload an ad.
        Task {
            await loadAd()
        }
        
        onDimiss?()
        onDimiss = nil
    }
    
    public func ad(
        _ ad: GADFullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        appOpenAd = nil
        isShowingAd = false
        // Reload an ad.
        Task {
            await loadAd()
        }
    }
}
