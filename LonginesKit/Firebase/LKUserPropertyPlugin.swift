//
//  LKUserPropertyPlugin.swift
//  LK
//
//  Created by liam on 16/5/24.
//

import Foundation
import FirebaseAnalytics
import Combine
import LonginesKit

public protocol LKUserPropertyPluggable: LKPluggableApplicationDelegateService {
    var didSetupO: AnyPublisher<Bool, Never> { get }
}


final public class LKUserPropertyPlugin: NSObject, LKUserPropertyPluggable {
    
    private var subscriptions = [AnyCancellable]()
    
    private let remoteConfigPlugin: LKRemoteConfigPluggable
    
    private let didSetupS = CurrentValueSubject<Bool, Never>(false)
    
    public init(remoteConfigPlugin: LKRemoteConfigPluggable) {
        self.remoteConfigPlugin = remoteConfigPlugin
        
        super.init()
    }
    
    public var didSetupO: AnyPublisher<Bool, Never> {
        didSetupS.eraseToAnyPublisher()
    }
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        remoteConfigPlugin.didActiveO
            .filter{ $0 }
            .prefix(1)
            .sink(receiveValue: { [weak self] result in
                guard let owner = self else { return }
                let userSegmentName: String = owner.remoteConfigPlugin.user_segment_name
                Analytics.setUserProperty(userSegmentName, forName: "user_segment_name")
                
                if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    Analytics.setUserProperty(version, forName: "current_app_version")
                }
                
                owner.didSetupS.send(true)
            })
            .store(in: &subscriptions)
        
        return true
    }
}
