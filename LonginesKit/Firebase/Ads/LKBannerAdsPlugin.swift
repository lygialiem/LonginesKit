//
//  LKBannerService.swift
//  LonginesKit
//
//  Created by liam on 29/6/24.
//

import UIKit
import LonginesKit
import GoogleMobileAds
import Combine

public class LKBannerAdsPlugin: NSObject, LKPluggableApplicationDelegateService, LKAdPluggable {
    
    public struct BannerInfo {
        let rootName: String
        let bannerView: GADBannerView
        let bannerDelegate: GADBannerViewDelegate
    }
    
    private var bannerInfos = [BannerInfo]()
    private var subscriptions = [AnyCancellable]()
    private var completion: LKValueAction<Status>?
    private var cancellables = Set<AnyCancellable>.init()
    
    public var config: LKAdvertisements
    
    required public init(config: LKAdvertisements) {
        self.config = config
        super.init()
    }
    
    public enum Status {
        case didLayout(container: UIView)
        case didRemove
    }
    
    public func updateConfig(_ config: LKAdvertisements) {
        self.config = config
    }
}

// MARK: - Attach/Detech
public extension LKBannerAdsPlugin {
    
    func attachBanner(from root: UIViewController, completion: LKValueAction<UIView>? = nil) {
        
        guard let id = config.bannerAdID, !id.isEmpty else { return }
        
        let delegate = LKBannerDelegate.init()
        
        delegate.statusCompletion = { status in
            switch status {
            case .didReiceiveAd(let bannerView):
            
               completion?(bannerView)
                
            case .didFailToReceiveAd:
                break
            }
        }
        
        
        let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = id
        bannerView.rootViewController = root
        bannerView.delegate = delegate
        bannerView.adSize = GADAdSizeBanner
        
        let request = GADRequest()
        bannerView.load(request)
        
        if !bannerInfos.contains(where: {$0.rootName == root.className }) {
            bannerInfos.append(.init(rootName: root.className,
                                     bannerView: bannerView,
                                     bannerDelegate: delegate))
        }
    }
    
    func detachBanner(rootName: String, completion: LKVoidAction? = nil) {
        guard let index = bannerInfos.firstIndex(where: {$0.rootName == rootName}) else {
            return
        }
        bannerInfos.remove(at: index)
        completion?()
    }
}

// MARK: - Delegate
class LKBannerDelegate: NSObject, GADBannerViewDelegate {
    
    enum Status {
        case didReiceiveAd(bannerView: GADBannerView)
        case didFailToReceiveAd(error: Error)
    }
    
    var statusCompletion: LKValueAction<Status>?
    
    // MARK: - Banner Delegate
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("[Banner]: ",#function)
        statusCompletion?(.didReiceiveAd(bannerView: bannerView))
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("[Banner]: ",#function)
        statusCompletion?(.didFailToReceiveAd(error: error))
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("[Banner]: ",#function)
    }
    
    func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
        print("[Banner]: ",#function)
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("[Banner]: ",#function)
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("[Banner]: ",#function)
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("[Banner]: ",#function)
    }
}
