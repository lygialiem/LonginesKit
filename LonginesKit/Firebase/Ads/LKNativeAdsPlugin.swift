//
//  LKNativeAdsPlugin.swift
//  LonginesKit
//
//  Created by liam on 16/7/24.
//

import Foundation
import GoogleMobileAds
import Combine
import LonginesKit

public class LKNativeAdPlugin: NSObject, LKPluggableApplicationDelegateService, LKAdPluggable {
    
    public func updateConfig(_ config: LKAdvertisements) {
        self.config = config
    }
    
    public var config: LKAdvertisements
    
    public required init(config: LKAdvertisements) {
        self.config = config
    }
    
    public convenience init(numberOfAds: Int = 3, config: LKAdvertisements) {
        self.init(config: config)
        self.numberOfAds = numberOfAds
    }
    
    private var adLoader: GADAdLoader?
    public var nativeAds = [GADNativeAd]()
    public let nativeAdsS = ReplayValueSubject<[GADNativeAd]>.init(bufferSize: 1)
    private var numberOfAds: Int = 3
    
    public func loadAds() {
        guard let id = config.nativeAdID, !id.isEmpty else { return }
        
        
        let options = GADMultipleAdsAdLoaderOptions.init()
        options.numberOfAds = numberOfAds
        let adLoader = GADAdLoader(adUnitID: id,
                                   rootViewController: nil,
                                   adTypes: [ .native ],
                                   options: [options])
        adLoader.delegate = self
        adLoader.load(.init())
        self.adLoader = adLoader
    }
    
    
}

extension LKNativeAdPlugin: GADNativeAdLoaderDelegate {
    
    public func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        
    }
    
    public func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        nativeAds.append(nativeAd)
        nativeAd.delegate = self
        nativeAdsS.send(nativeAds)
    }
    
    public func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        
    }
}

extension LKNativeAdPlugin: GADNativeAdDelegate {
    
    public func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        
    }
    
    public func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        
    }
}
