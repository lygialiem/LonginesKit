import Foundation
import Qonversion

public struct LKIAPModel {
    public enum Duration: String {
        case weekly
        case monthly
        case yearly
        case lifetime
        
        public var title: String {
            rawValue.capitalized
        }
    }
    
   public let qonversionID: String
   public let storeID: String
   public let description: String
   public let price: String
    
    public var isTrial: Bool {
        return storeID.lowercased().contains("trial")
    }
    
    public var title: String {
        return duration?.title ?? "Premium"
    }
    
    public var duration: Duration? {
        switch storeID.lowercased() {
        case let x where x.contains("week"):
            return .weekly
        case let x where x.contains("month"):
            return .monthly
        case let x where x.contains("year"):
            return .yearly
        case let x where x.contains("lifetime"):
            return .lifetime
        default:
            return nil
        }
    }
}
