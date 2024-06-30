//
//  ASBaseView.swift
//  AIStudy
//
//  Created by liam on 22/08/2023.
//

import UIKit

open class LKBaseView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        visualize()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupViews() {
    }
    
    open func visualize() {
    }
}
