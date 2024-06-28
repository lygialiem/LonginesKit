//
//  IRFirebaseConfig.swift
//  AIInteriorRoom
//
//  Created by liam on 27/10/2023.
//

import Foundation
import FirebaseCore
import GoogleMobileAds
import Combine
import LonginesKit

public protocol LKFirebaseConfigPluggable: LKPluggableApplicationDelegateService {
    
    var didConfigureO: AnyPublisher<Bool, Never> { get }
}

final public class LKFirebaseConfigPlugin: NSObject {
    
    private let didConfigS = CurrentValueSubject<Bool, Never>(false)
    
    private let options: FirebaseOptions?
    
    private let testDeviceIDs: [String]
    
    public init(options: FirebaseOptions? = nil, testDeviceIDs: [String] = []) {
        self.options = options
        self.testDeviceIDs = testDeviceIDs
        super.init()
    }
}

extension LKFirebaseConfigPlugin: LKFirebaseConfigPluggable {
    
    public var didConfigureO: AnyPublisher<Bool, Never> {
        didConfigS.eraseToAnyPublisher()
    }
}

extension LKFirebaseConfigPlugin {
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        guard let _ = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
            fatalError("Coult not load GoogleService-Info.plist'.")
        }
    
        if let options {
            FirebaseApp.configure(options: options)
        } else {
            FirebaseApp.configure()
            GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = testDeviceIDs
        }
        didConfigS.send(true)
        return true
    }
}
