import Foundation
import UIKit

public extension UIColor {
    class func orderStatusAcceptedColor() -> UIColor {
        return UIColor(red: 59.0/255, green: 189.0/255, blue: 142.0/255, alpha: 1.0)
    }
    
    class func orderStatusDeclinedColor() -> UIColor {
        return UIColor(red: 237.0/255, green: 77.0/255, blue: 96.0/255, alpha: 1.0)
    }
    
    class func orderStatusPartiallyAcceptedColor() -> UIColor {
        return UIColor(red: 77.0/255, green: 124.0/255, blue: 254.0/255, alpha: 1.0)
    }
    
    class func orderStatusPendingColor() -> UIColor {
        return UIColor(red: 242.0/255, green: 191.0/255, blue: 16.0/255, alpha: 1.0)
    }
    
    class func ordersTableViewShadowColor() -> UIColor {
        return UIColor(red: 117.0/255, green: 128.0/255, blue: 141.0/255, alpha: 0.12)
    }
    
    class func navigationItemTextColor() -> UIColor {
        return UIColor(red: 37.0/255, green: 38.0/255, blue: 49.0/255, alpha: 1.0)
    }
    
    class func navigationItemShadowColor() -> UIColor {
        return UIColor(red: 220.0/255, green: 224.0/255, blue: 229.0/255, alpha: 1.0)
    }
    
    class func distributorLogoBorderColor() -> UIColor {
        return UIColor(red: 222.0/255, green: 225.0/255, blue: 228.0/255, alpha: 1.0)
    }
    
    class func acceptOrderShadowColor() -> UIColor {
        return UIColor(red: 77.0/255, green: 124.0/255, blue: 254.0/255, alpha: 1.0)
    }
}
