//
//  LKAdvertisementPlugin.swift
//  LonginesKit
//
//  Created by liam on 16/7/24.
//

import Combine
import LonginesKit
import UIKit

public protocol LKAdPluggable {
    func updateConfig(_ config: LKAdvertisements)
    var config: LKAdvertisements { get set }
    init(config: LKAdvertisements)
}

public class LKAdvertisementPlugin: NSObject, LKPluggableApplicationDelegateService {
    
    private var cancellables = Set<AnyCancellable>.init()
    
    private let advertisementsSubject = CurrentValueSubject<LKAdvertisements?, Never>.init(nil)
    
    
    
    public var bannerAdPlugin: LKBannerAdsPlugin?
    public var interstitialAdPlugin: LKInterstitialAdsPlugin?
    
    private let ads: [any LKAdPluggable]
    
    public init(ads: [any LKAdPluggable]) {
        self.ads = ads
    }
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        guard let remoteConfigPlugin = LKPluggableTool.queryAppDelegate(for: LKRemoteConfigPluggable.self) else  {
            return true
        }
        remoteConfigPlugin.didActiveO
            .filter{$0}
            .sink { [weak self] isActived in
                let advertisements: String = remoteConfigPlugin.advertisements
                guard !advertisements.isEmpty,
                      let config = advertisements.decoded(LKAdvertisements.self)
                else {
                    return
                }
                self?.advertisementsSubject.send(config)
                self?.ads.forEach({ ad in
                    ad.updateConfig(config)
                })
            }
            .store(in: &cancellables)
        return true
    }
}

public extension LKAdvertisementPlugin {
    var advertisementsPublisher: AnyPublisher<LKAdvertisements?, Never> {
        advertisementsSubject.eraseToAnyPublisher()
    }
}


public struct LKAdvertisements: Decodable {
    
    public init(bannerAdID: String? = nil, interstitialAdID: String? = nil, rewardedAdID: String? = nil, nativeAdID: String? = nil) {
        self.bannerAdID = bannerAdID
        self.interstitialAdID = interstitialAdID
        self.rewardedAdID = rewardedAdID
        self.nativeAdID = nativeAdID
    }
    
    var bannerAdID: String?
    var interstitialAdID: String?
    var rewardedAdID: String?
    var nativeAdID: String?
}

public protocol LKAdConfigurable {
    var id: String { get }
}
