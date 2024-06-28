//
//  ViewController.swift
//  AppSample
//
//  Created by liam on 24/6/24.
//

import UIKit
import LonginesKit
import LonginesFirebase

class HomeViewController: LKBaseViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let remoteConfigPlugin = LKPluggableTool.queryAppDelegate(for: LKRemoteConfigPluggable.self)
        remoteConfigPlugin?.didActiveO
            .filter{$0}
            .sink(receiveValue: { isActived in
                
            })
    }
}
