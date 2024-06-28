import Foundation
import FirebaseCore
import Combine
import FirebaseRemoteConfigInterop
import FirebaseRemoteConfig
import LonginesKit

@dynamicMemberLookup
public protocol LKRemoteConfigPluggable: LKPluggableApplicationDelegateService {
    
    subscript(dynamicMember key: String) -> Bool { get }
    
    subscript(dynamicMember key: String) -> Data { get }
    
    subscript(dynamicMember key: String) -> String { get }
    
    subscript(dynamicMember key: String) -> Float { get }
    
    subscript(dynamicMember key: String) -> Double { get }
    
    subscript(dynamicMember key: String) -> String? { get }
    
    subscript<T>(dynamicMember key: String) -> T where T: SignedInteger { get }
    
    subscript<T>(dynamicMember key: String) -> T where T: UnsignedInteger { get }
    
    subscript(dynamicMember key: String) -> Float? { get }
    
    subscript(dynamicMember key: String) -> Double? { get }
    
    var didActiveO: AnyPublisher<Bool, Never> { get }
}


final public class LKRemoteConfigPlugin: NSObject, LKRemoteConfigPluggable {
    
    private let didActiveS = CurrentValueSubject<Bool, Never>(false)
    private var subscriptions = [AnyCancellable]()
    
    private let firebaseConfigPlugin: LKFirebaseConfigPluggable
    
    public init(firebasePlugin: LKFirebaseConfigPluggable) {
        self.firebaseConfigPlugin = firebasePlugin
        super.init()
    }
    
    private lazy var remoteConfig: RemoteConfig = {
        let rc = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        rc.configSettings = settings
        return rc
    }()
}

public extension LKRemoteConfigPlugin {
    
    var didActiveO: AnyPublisher<Bool, Never> {
        didActiveS.eraseToAnyPublisher()
    }
}

private extension LKRemoteConfigPlugin {
    
    func setupRx() {
        firebaseConfigPlugin.didConfigureO
            .filter{$0}
            .sink(receiveValue: { [weak self] didConfig in
                self?.setup()
            })
            .store(in: &subscriptions)
    }
    
    func setup() {
        let expiredSeconds: TimeInterval = 60 * 30
        remoteConfig.fetch(withExpirationDuration: expiredSeconds) { [weak self] (status, error) -> Void in
            guard let self else { return }
            guard status == .success else {
                self.didActiveS.send(false)
                return
            }
            self.remoteConfig.activate { changed, error in
                self.didActiveS.send(true)
            }
        }
        
        remoteConfig.addOnConfigUpdateListener { [weak self] configUpdate, error in
            guard let self else { return }
            guard let configUpdate, error == nil else {
                return
            }
            print("Updated keys: \(configUpdate.updatedKeys)")
            
            self.remoteConfig.activate { changed, error in
                guard error == nil else {
                    self.didActiveS.send(false)
                    return
                }
                self.didActiveS.send(true)
            }
        }
    }
}

extension LKRemoteConfigPlugin {
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupRx()
        return true
    }
}

public extension LKRemoteConfigPlugin {
    
    /// Bool.
    subscript(dynamicMember key: String) -> Bool {
        return remoteConfig[key].boolValue
    }
    
    /// Data.
    subscript(dynamicMember key: String) -> Data {
        return remoteConfig[key].dataValue
    }
    
    /// String.
    subscript(dynamicMember key: String) -> String? {
        return remoteConfig[key].stringValue
    }
    
    subscript(dynamicMember key: String) -> String {
        return self[dynamicMember: key] ?? ""
    }
    
    /// Signed/Unsigned integer.
    subscript<T>(dynamicMember key: String) -> T where T: SignedInteger {
        let n = RemoteConfig.remoteConfig()[key].numberValue
        return numericCast(n.int64Value)
    }
    
    subscript<T>(dynamicMember key: String) -> T where T: UnsignedInteger {
        let n = RemoteConfig.remoteConfig()[key].numberValue
        return numericCast(n.uint64Value)
    }
    
    /// Float.
    subscript(dynamicMember key: String) -> Float? {
        return RemoteConfig.remoteConfig()[key].numberValue.floatValue
    }
    
    subscript(dynamicMember key: String) -> Float {
        return self[dynamicMember: key] ?? 0.0
    }
    
    /// Double.
    subscript(dynamicMember key: String) -> Double? {
        let n = RemoteConfig.remoteConfig()[key].numberValue
        return n.doubleValue
    }
    
    subscript(dynamicMember key: String) -> Double {
        return self[dynamicMember: key] ?? 0.0
    }
}
