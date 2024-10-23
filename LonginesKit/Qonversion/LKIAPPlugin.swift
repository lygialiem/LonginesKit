import Foundation
import LonginesFirebase
import Qonversion
import Combine
import LonginesKit

public final class LKIAPPlugin: NSObject, LKPluggableApplicationDelegateService {
    
    public enum PurchaseState {
        case cancel
        case purchased
        case error(Error)
    }
    
    // MARK: Public
    public var productListsS = CurrentValueSubject<[LKIAPModel], Never>.init([])
    
    // MARK: Private
    private let purchasedModelS = CurrentValueSubject<LKIAPPurchaseModel, Never>.init(LKIAPPurchaseModel(isPurchased: false))
    
    private let didCheckPermissionS = CurrentValueSubject<Bool, Never>(false)
    
    private var subscriptions = [AnyCancellable]()
    
    @LKUserDefaultWrapper("qonversionOffering", defaultValue: "")
    private var qonversionOffering: String
    
    public init(projectKey: String) {
        Qonversion.initWithConfig(.init(projectKey: projectKey, launchMode: .subscriptionManagement))
        super.init()
       
    }
}

// MARK: - Public
public extension LKIAPPlugin {
    
    var didCheckPermissionO: AnyPublisher<Bool, Never> {
        didCheckPermissionS.eraseToAnyPublisher()
    }
    
    var productsListO: AnyPublisher<[LKIAPModel], Never> {
        productListsS.eraseToAnyPublisher()
    }
    
    var productList: [LKIAPModel] {
        productListsS.value
    }
    
    var puchasedModelO: AnyPublisher<LKIAPPurchaseModel, Never> {
        purchasedModelS.eraseToAnyPublisher()
    }
    
    var isPremiumUserO: AnyPublisher<Bool, Never> {
        return purchasedModelS.map{$0.isPurchased}.eraseToAnyPublisher()
    }
    
    var isPremiumUser: Bool {
        return purchasedModelS.value.isPurchased
    }
    
    func updatePurchase(isPurchased: Bool) {
        purchasedModelS.send(.init(isPurchased: isPurchased))
    }
}

// MARK: - Private
private extension LKIAPPlugin {
    
    func initialize() {
        Task {
            await checkPermission()
            didCheckPermissionS.send(true)
        }
        
        let remoteConfigPlugin = LKPluggableTool.queryAppDelegate(for: LKRemoteConfigPluggable.self)!
        remoteConfigPlugin.didActiveO
            .filter{$0}
            .sink(receiveValue: { [weak self] _ in guard let owner = self else { return }
                let qonversionOffering: String = remoteConfigPlugin.qonversion_offering
                if qonversionOffering.isEmpty {
                    owner.qonversionOffering = "premium"
                } else {
                    owner.qonversionOffering = qonversionOffering
                }
                
                Task {
                    await owner.prepareProducts()
                }
            })
            .store(in: &subscriptions)
    }
    
    func checkPermission() async {
        // check isPremium
        async let checkPermissionResult = await checkPermissions()
        switch await checkPermissionResult {
        case .success(let isActive):
            updatePurchase(isPurchased: isActive)
            print("[Qonversion] check permisison success:", isActive)
        case .failure(let error):
            print("[Qonversion] check permisison error:", error.localizedDescription)
        }
    }
     
     func prepareProducts() async {
         // fetching products
         async let fetchResult = await fetchProducts()
         switch await fetchResult {
         case .success(let products):
             productListsS.send(products)
             print("[Qonversion] fetch products success:", products)
         case .failure(let error):
             print("[Qonversion] fetch products error:", error.localizedDescription)
         }
     }
}

extension LKIAPPlugin {
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        Qonversion.shared().collectAppleSearchAdsAttribution()
        if let analyticPlugin = LKPluggableTool.queryAppDelegate(for: LKAnalyticPluggable.self),
           let appInstanceID = analyticPlugin.appInstanceID
        {
            Qonversion.shared().setUserProperty(.firebaseAppInstanceId, value: appInstanceID)
        }
        
        DispatchQueue.main.async {
            self.initialize()
        }
        return true
    }
}

// MARK: - Qonversion Tools
public extension LKIAPPlugin {
    
    func fetchProducts() async -> Result<[LKIAPModel], Error> {
        await withCheckedContinuation { continuation in
            Qonversion.shared().offerings { (offerings, error) in
                if let error {
                    continuation.resume(returning: .failure(error))
                    return
                }
                if let products = offerings?.availableOfferings
                    .first(where: { $0.identifier == self.qonversionOffering})?.products {
                    let models = products.map{LKIAPModel.init(qonversonProduct: $0)}
                    continuation.resume(returning: .success(models))
                } else {
                    continuation.resume(returning: .failure(LKIAPError.fetchProductFailed))
                }
            }
        }
    }
    
    func checkPermissions() async -> Result<Bool, Error> {
        await withCheckedContinuation { continuation in
            Qonversion.shared().checkEntitlements { permissions, error in
                if let error {
                    continuation.resume(returning: .failure(error))
                    return
                }
                if let premium = permissions["premium"] {
                    continuation.resume(returning: .success(premium.isActive))
                } else {
                    continuation.resume(returning: .success(false))
                }
            }
        }
    }
    
    private func trackSubscriptons(productID: String) {
        if productID.contains("lifetime") {
            LKIAPEventTracking.purchase_lifetime.track()
        } else {
            "subscribe_\(productID)".track()
        }
    }
    
    @discardableResult
    func purchase(product: String) async -> PurchaseState {
        await withCheckedContinuation { continuation in
            Qonversion.shared().purchase(product) { result, error, cancelled in
                if let error {
                    if cancelled {
                        continuation.resume(returning: .cancel)
                    } else {
                        continuation.resume(returning: .error(error))
                    }
                }
                else {
                    if let permission = result["premium"] {
                        if permission.isActive {
                            self.updatePurchase(isPurchased: permission.isActive)
                            self.trackSubscriptons(productID: permission.productID)
                            
                            continuation.resume(returning: .purchased)
                        } else {
                            continuation.resume(returning: .error(LKIAPError.didMadePurchaseButActiveFalse))
                        }
                    } else {
                        continuation.resume(returning: .error(LKIAPError.emptyPermissions))
                    }
                }
                
            }
        }
    }
    
    func restorePurchase() async -> Result<Bool, Error>{
        await withCheckedContinuation { continuation in
            Qonversion.shared().restore { permissons, error in
                if let error {
                    continuation.resume(returning: .failure(error))
                } else {
                    if let permission = permissons["premium"] {
                        if permission.isActive {
                            self.updatePurchase(isPurchased: permission.isActive)
                        }
                        continuation.resume(returning: .success(permission.isActive))
                    } else {
                        continuation.resume(returning: .failure(LKIAPError.emptyPermissions))
                    }
                }
            }
        }
    }
}

/*== qonversion initialize:
 
 permisson: ["premium": <QNPermission: id=premium,
 isActive=1,
 productID=weeklytrial,
 renewState=will renew (enum value = 1),
 source=App Store (enum value = 1),
 startedDate=2023-11-28 06:57:23 +0000,
 expirationDate=2023-11-28 17:07:38 +0000,
 >]
 
 products: ["lifetime": <QNProduct: id=lifetime,
 storeID=tinyleo.com.interiorroom.lifetime,
 offeringID=(null),
 type=one time (enum value = 2),
 duration=unknown (enum value = -1),
 trial duration=not available (enum value = -1),
 skProduct=(null),
 >, "weeklytrial": <QNProduct: id=weeklytrial,
 storeID=tinyleo.com.interiorroom.weeklytrial,
 offeringID=(null),
 type=trial (enum value = 0),
 duration=weekly (enum value = 0),
 trial duration=not available (enum value = -1),
 skProduct=(null),
 >, "yearly": <QNProduct: id=yearly,
 storeID=tinyleo.com.interiorroom.yearly,
 offeringID=(null),
 type=direct subscription (enum value = 1),
 duration=annual (enum value = 4),
 trial duration=not available (enum value = -1),
 skProduct=(null),
 >]
 
 offerings: Optional(<QNOfferings: 0x2821804c0>)
 
 user product: ["weeklytrial": <QNProduct: id=weeklytrial,
 storeID=tinyleo.com.interiorroom.weeklytrial,
 offeringID=(null),
 type=trial (enum value = 0),
 duration=weekly (enum value = 0),
 trial duration=not available (enum value = -1),
 skProduct=(null),
 >]
 */



/*
 print("== purchase result:", result)
 == purchase result: ["premium": <QNPermission: id=premium,
 isActive=1,
 productID=weeklytrial,
 renewState=will renew (enum value = 1),
 source=App Store (enum value = 1),
 startedDate=2023-11-28 06:57:23 +0000,
 expirationDate=2023-11-28 16:43:38 +0000,
 >]
 */

