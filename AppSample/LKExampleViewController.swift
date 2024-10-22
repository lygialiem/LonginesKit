//
//  ViewController.swift
//  AppSample
//
//  Created by liam on 24/6/24.
//

import UIKit
import LonginesKit
import LonginesFirebase
import LonginesQonversion
import Combine

class LKExampleViewController: LKBaseViewController {
    
    private var subscriptions = [AnyCancellable]()
    
    private var iapPlugin = LKPluggableTool.queryAppDelegate(for: LKIAPPlugin.self)!
    
    private lazy var showInterstitialAdButton = createButton(title: "Show Interstitial Ad")
    
    private lazy var showBannerAdButton = createButton(title: "Show Banner Ad")
    
    private lazy var showRewardedAdButton = createButton(title: "Show Rewarded Ad")
    
    private lazy var showNativeAdButton = createButton(title: "Show Native Ad")
    
    private lazy var showAppOpenAdButton = createButton(title: "Show App Open Ad")
    
    private lazy var purchaseButton = createButton(title: "Purchase IAP item")
    
    private let rewardedAdPlugin = LKPluggableTool.queryAppDelegate(for: LKRewardedAdPlugin.self)!
    
    private let interstitialPlugin = LKPluggableTool.queryAppDelegate(for: LKInterstitialAdsPlugin.self)!
    
    private let bannerPlugin = LKPluggableTool.queryAppDelegate(for: LKBannerAdsPlugin.self)!
    
    private let nativeAdPlugin = LKPluggableTool.queryAppDelegate(for: LKNativeAdPlugin.self)!
    
    private let appOpenAdPlugin = LKPluggableTool.queryAppDelegate(for: LKAppOpenAdsPlugin.self)!
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView.init()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func createButton(title: String) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .brown
        config.title = title
        config.titleAlignment = .center
        let button = UIButton.init(configuration: config)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.0
        button.frame.size.height = 80
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        super.setupViews()
        
        view.backgroundColor = .lightGray
        
       
        
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubviews(showBannerAdButton,
                                          showInterstitialAdButton,
                                          showRewardedAdButton,
                                          showNativeAdButton,
                                          showAppOpenAdButton,
                                          purchaseButton)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        mainStackView.arrangedSubviews.forEach { view in
            view.alpha = 0.5
            view.isUserInteractionEnabled = false
        }
        
        Task {
            await appOpenAdPlugin.loadAd()
        }
    }
    
    override func visualize() {
        super.visualize()
        
        iapPlugin.didCheckPermissionO
            .receive(on: DispatchQueue.main)
            .filter{$0}
            .sink { [weak self] _ in
                self?.startBusiness()
            }
            .store(in: &subscriptions)
        
        showAppOpenAdButton.addAction(.init(handler: { [weak self] _ in
            self?.appOpenAdPlugin.present() {
                print(1)
            }
        }), for: .touchUpInside)
        
        showInterstitialAdButton.addAction(.init(handler: { [weak self] _ in
            guard let self else { return }
            self.interstitialPlugin.presentInterstitial(from: self, onDismiss: nil)
        }), for: .touchUpInside)
        
        
        showBannerAdButton.addAction(.init(handler: { [weak self] _ in
            guard let self else { return }
            
            let vc = LKBannerViewController.init()
            vc.modalPresentationStyle = .automatic
            
            self.present(vc, animated: true)
        }), for: .touchUpInside)
        
        showRewardedAdButton.addAction(.init(handler: {  [weak self] _ in
            guard let self else { return }
            self.rewardedAdPlugin.presentRewardedAd(at: self) { status in
                loggingPrint(status)
            }
            
        }), for: .touchUpInside)
        
        showNativeAdButton.addAction(.init(handler: { [weak self] _ in
            guard let self else { return }
            self.nativeAdPlugin.didReceiveAd
                .sink { ad in
                    print("== Native Ads:", ad)
                }
                .store(in: &self.subscriptions)
            
            self.nativeAdPlugin.loadAds()
            
        }), for: .touchUpInside)
        
        purchaseButton.addAction(.init(handler: { [weak self] _ in guard let self else { return }
            self.iapPlugin.didCheckPermissionO
                .sink { success in
                    guard !self.iapPlugin.isPremiumUser else { return }
                    Task {
                        let item = self.iapPlugin.productList.first!
                        let state = await self.iapPlugin.purchase(product: item.qonversionID)
                        print("== state:", state)
                    }
                }
                .store(in: &subscriptions)
        }), for: .touchUpInside)
    }
}

private extension LKExampleViewController {
    
    func startBusiness() {
        mainStackView.arrangedSubviews.forEach { view in
            view.alpha = 1.0
            view.isUserInteractionEnabled = true
        }
        interstitialPlugin.loadInterstitial()
        rewardedAdPlugin.loadRewardedAd()
    }
}
