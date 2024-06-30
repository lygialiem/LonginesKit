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

class HomeViewController: LKBaseViewController {
    
    private var subscriptions = [AnyCancellable]()
    
    private var iapPlugin = LKPluggableTool.queryAppDelegate(for: LKIAPPlugin.self)
    
    private lazy var showInterstitialAdButton = createButton(title: "Show Interstitial Ad")
    
    private lazy var showBannerAdButton = createButton(title: "Show Banner Ad")
    
    private lazy var purchaseButton = createButton(title: "Purchase IAP item")
    
    private var interstitialPlugin = LKPluggableTool.queryAppDelegate(for: LKInterstitialAdsPlugin.self)
    
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
        mainStackView.addArrangedSubviews(showBannerAdButton, showInterstitialAdButton, purchaseButton)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        mainStackView.arrangedSubviews.forEach { view in
            view.alpha = 0.5
            view.isUserInteractionEnabled = false
        }
    }
    
    override func visualize() {
        super.visualize()
        
        showInterstitialAdButton.addAction(.init(handler: { [weak self] _ in
            guard let self else { return }
            self.interstitialPlugin?.presentInterstitial(from: self, onDismiss: nil)
        }), for: .touchUpInside)
        
        
        showBannerAdButton.addAction(.init(handler: { [weak self] _ in
            guard let self else { return }
            if let bannerPlugin = LKPluggableTool.queryAppDelegate(for: LKBannerAdsPlugin.self),
               !self.iapPlugin!.isPremiumUser
            {
                bannerPlugin.attachBanner(from: self)
            }
        }), for: .touchUpInside)
        
        purchaseButton.addAction(.init(handler: { [weak self] _ in guard let self else { return }
            if let iapPlugin = self.iapPlugin {
                iapPlugin.didCheckPermissionO
                    .sink { success in
                        if success, !iapPlugin.isPremiumUser {
                            Task {
                                let item = iapPlugin.productList.first!
                                let state = await iapPlugin.purchase(product: item.qonversionID)
                                print("== state:", state)
                            }
                        }
                    }
                    .store(in: &subscriptions)
            }
        }), for: .touchUpInside)
        
        
        guard let iapPlugin else { return }
        iapPlugin.didCheckPermissionO
            .receive(on: DispatchQueue.main)
            .filter{$0}
            .sink { [weak self] _ in
                self?.startBusiness()
            }
            .store(in: &subscriptions)
        
    }
}

private extension HomeViewController {
    
    func startBusiness() {
        mainStackView.arrangedSubviews.forEach { view in
            view.alpha = 1.0
            view.isUserInteractionEnabled = true
        }
        interstitialPlugin?.loadInterstitial()
    }
}
