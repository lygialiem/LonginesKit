//
//  UIView Wxt.swift
//  LonginesKit
//
//  Created by liam on 24/6/24.
//

import UIKit

extension UIView {
    
    public static var viewIdentifier: String {
        String.init(describing: self)
    }
    
    public func addSubviews(_ subviews: UIView...) {
        subviews.forEach { view in
            addSubview(view)
        }
    }
    
    public func addThisChild(_ child: UIViewController) {
        guard let parentViewController = self.parentViewController else {
            return
        }
        parentViewController.addChild(child)
        addSubview(child.view)
        
        child.view.translatesAutoresizingMaskIntoConstraints = false
        child.view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        child.view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        child.view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        child.view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        child.didMove(toParent: parentViewController)
    }

   public var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }

}
