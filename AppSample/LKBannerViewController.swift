//
//  LKBannerViewController.swift
//  AppSample
//
//  Created by liam on 20/10/24.
//

import UIKit
import LonginesKit
import LonginesFirebase

final class LKBannerViewController: LKBaseViewController {
    
    private let bannerPlugin = LKPluggableTool.queryAppDelegate(for: LKBannerAdsPlugin.self)!
    
    override func setupViews() {
        super.setupViews()
        
        view.backgroundColor = .systemBlue
        
        bannerPlugin.attachBanner(from: self) { banner in
        }
    }
    
    deinit {
        bannerPlugin.detachBanner(from: self)
        print("== deinit: \(self.className)")
    }
}
