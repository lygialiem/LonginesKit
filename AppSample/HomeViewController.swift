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
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        super.setupViews()
        
        view.backgroundColor = .lightGray
        
        if let iapPlugin = LKPluggableTool.queryAppDelegate(for: LKIAPPlugin.self) {
            iapPlugin.didCheckPermissionO
                .sink { success in
                    if success {
                        iapPlugin.productList.forEach { product in
                            print("== product:", product.qonversionID)
                        }
                    }
                }
                .store(in: &subscriptions)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let bannerPlugin = LKPluggableTool.queryAppDelegate(for: LKBannerAdsPlugin.self) {
            bannerPlugin.attachBanner(from: self)
        }
    }
}
