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

public class LKNativeAdPlugin: NSObject, LKPluggableApplicationDelegateService {
    
    public struct Config {
        let numberOfAds: Int
        
        public init(numberOfAds: Int = 5) {
            self.numberOfAds = numberOfAds
        }
    }
    
    private var adLoader: GADAdLoader?
    public var nativeAds = [GADNativeAd]()
    public let nativeAdsS = ReplayValueSubject<[GADNativeAd]>.init(bufferSize: 1)
    private let config: Config
    
    private let id: String
    
    public init(id: String = "ca-app-pub-3940256099942544/3986624511",
                config: Config = .init()) {
        self.id = id
        self.config = config
        
        super.init()
    }
    
   public func loadAds() {
        let options = GADMultipleAdsAdLoaderOptions.init()
        options.numberOfAds = config.numberOfAds
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
