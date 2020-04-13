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
}
