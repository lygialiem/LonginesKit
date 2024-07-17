//
//  LKTableAnimatedCell.swift
//  LonginesKit
//
//  Created by liam on 18/7/24.
//

import Foundation
import UIKit

public protocol ASAnimatedCellProtocol {
    var animated: Bool { get }
    var animationScale: CGFloat { get }
    var animationDuration: TimeInterval { get }
    var animationScaleTime: TimeInterval { get }
}

public extension ASAnimatedCellProtocol {
    var animated: Bool {
        return true
    }

    var animationScale: CGFloat {
        return animated ? 0.98 : 1.0
    }

    var animationDuration: TimeInterval {
        return animated ? 0.5 : 0
    }

    var animationScaleTime: TimeInterval {
        return animated ? 0.15 : 0
    }
}

open class LKAnimatedTableViewCell: UITableViewCell, ASAnimatedCellProtocol {
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: animationDuration) {
            self.transform = CGAffineTransform(scaleX: self.animationScale, y: self.animationScale)
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        endAnimation()
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        endAnimation()
    }

    private func endAnimation() {
        UIView.animate(withDuration: animationDuration, delay: animationScaleTime, usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 5.0, options: .allowUserInteraction) {
            self.transform = .identity
        }
    }
}

open class LKAnimatedCollectionViewCell: UICollectionViewCell, ASAnimatedCellProtocol {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: animationDuration) {
            self.transform = CGAffineTransform(scaleX: self.animationScale, y: self.animationScale)
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        endAnimation()
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        endAnimation()
    }

    private func endAnimation() {
        UIView.animate(withDuration: animationDuration, delay: animationScaleTime, usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 5.0, options: .allowUserInteraction) {
            self.transform = .identity
        }
    }
}


