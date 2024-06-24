//
//  UIStackView Ext.swift
//  LonginesKit
//
//  Created by liam on 24/6/24.
//

import UIKit

extension UIStackView {
    
   public func addArrangedSubviews(_ subviews: UIView...) {
        subviews.forEach { view in
            addArrangedSubview(view)
        }
    }
}
