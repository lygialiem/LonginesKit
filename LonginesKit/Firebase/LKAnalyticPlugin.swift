//
//  LKAnalyticPlugin.swift
//  LonginesKit
//
//  Created by liam on 29/6/24.
//

import FirebaseAnalytics
import Foundation
import Combine
import LonginesKit

public protocol LKAnalyticPluggable: LKPluggableApplicationDelegateService {
    var didSetupO: AnyPublisher<Bool, Never> { get }
}

public class LKAnalyticPlugin: NSObject, LKAnalyticPluggable {
    
    public var didSetupO: AnyPublisher<Bool, Never> {
        didSetupS.eraseToAnyPublisher()
    }
    
    private let didSetupS = CurrentValueSubject<Bool, Never>(false)
    
    private var subscriptions = [AnyCancellable]()
    
    private let firebasePlugin: LKFirebaseConfigPluggable
    
    public init(firebasePlugin: LKFirebaseConfigPluggable) {
        self.firebasePlugin = firebasePlugin
    }
}

extension LKAnalyticPlugin {
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        firebasePlugin.didConfigureO
            .filter{$0}
            .sink { [weak self] _ in
                self?.setup()
            }
            .store(in: &subscriptions)
        return true
    }
}

private extension LKAnalyticPlugin {
    func setup() {
        Analytics.setAnalyticsCollectionEnabled(true)
        
        didSetupS.send(true)
    }
}

// Track Function
public extension String {
    func track(params: [String: Any]? = nil) {
        Analytics.logEvent(self, parameters: params)
        loggingPrint("""
++++++++++ Tracked Event: "\(self)" ++++++++++
""")
    }
}