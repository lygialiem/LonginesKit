//
//  LKBaseViewController.swift
//  LonginesKit
//
//  Created by liam on 24/6/24.
//

import UIKit

open class LKBaseViewController: UIViewController {
 
    open override func loadView() {
        super.loadView()
        setupViews()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        visualize()
    }
    
    open func setupViews() {
        
    }
    
    open func visualize() {
        
    }
}
