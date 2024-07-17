//
//  Cell Ext.swift
//  LonginesKit
//
//  Created by liam on 18/7/24.
//

import UIKit

extension UITableView {
   public func dequeueCell<T: UITableViewCell>(type: T.Type, _ indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.viewIdentifier, for: indexPath) as! T
    }
}
