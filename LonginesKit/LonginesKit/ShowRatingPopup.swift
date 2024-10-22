//
//  ShowRatingPopup.swift
//  LonginesKit
//
//  Created by liam on 22/10/24.
//

import Foundation
import StoreKit

func showRatingPopup() {
    guard let scene = UIApplication.windowScene else { return }
    SKStoreReviewController.requestReview(in: scene)
}
