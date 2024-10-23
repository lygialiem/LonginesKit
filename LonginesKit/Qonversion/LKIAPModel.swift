import Foundation
import Qonversion

public struct LKIAPModel {
    
    public let qonversonProduct: Qonversion.Product
    
    public var isTrial: Bool {
        guard let trialPeriod = qonversonProduct.trialPeriod, trialPeriod.unitCount != 0 else {
            return false
        }
        return true
    }
}
