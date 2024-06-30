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

public class LKBannerAdsPlugin: NSObject, LKPluggableApplicationDelegateService {
    
    public struct BannerInfo {
        let rootName: String
        let container: UIView
        let bannerView: GADBannerView
        let bannerDelegate: GADBannerViewDelegate
    }
    
    private var bannerInfos = [BannerInfo]()
    private var subscriptions = [AnyCancellable]()
    private var completion: LKValueAction<Status>?
    
    public enum Status {
        case didLayout(container: UIView)
        case didRemove
    }
    
    private let id: String
    
    public init(id: String = "ca-app-pub-3940256099942544/2435281174") {
        self.id = id
        
        super.init()
    }
}

// MARK: - Attach/Detech
public extension LKBannerAdsPlugin {
    
    func attachBanner(from root: UIViewController) {
        let container = UIView.init()
        let delegate = LKBannerDelegate.init()
        delegate.statusCompletion = { [weak self, container] status in
            switch status {
            case .didReiceiveAd(let bannerView):
                
                let containerSuperView = root.view!
                containerSuperView.addSubview(container)
                container.addSubview(bannerView)
                
                [bannerView, container].forEach { view in
                    view.translatesAutoresizingMaskIntoConstraints = false
                }
                
                NSLayoutConstraint.activate([
                    bannerView.topAnchor.constraint(equalTo: container.topAnchor),
                    bannerView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                    bannerView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                    bannerView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                    
                    container.leadingAnchor.constraint(equalTo: containerSuperView.leadingAnchor),
                    container.trailingAnchor.constraint(equalTo: containerSuperView.trailingAnchor),
                    container.bottomAnchor.constraint(equalTo: containerSuperView.safeAreaLayoutGuide.bottomAnchor),
                ])
                
                self?.completion?(.didLayout(container: container))
                self?.completion = nil
                
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
                                     container: container,
                                     bannerView: bannerView,
                                     bannerDelegate: delegate))
        }
    }
    
    func detachBanner(from root: UIViewController) {
        guard let index = bannerInfos.firstIndex(where: {$0.rootName == root.className}) else {
            return
        }
        bannerInfos[index].container.removeFromSuperview()
        bannerInfos.remove(at: index)
        completion?(.didRemove)
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
