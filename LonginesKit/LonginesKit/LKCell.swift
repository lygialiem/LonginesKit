//
//  LKCell.swift
//  LonginesKit
//
//  Created by liam on 24/6/24.
//

import UIKit

extension UICollectionReusableView {
    public static var identifier: String {
        String.init(describing: self)
    }
}

extension UITableViewCell {
    public static var identifier: String {
        String.init(describing: self)
    }
}
