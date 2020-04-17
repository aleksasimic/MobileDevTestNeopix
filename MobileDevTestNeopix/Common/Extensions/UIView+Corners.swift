import Foundation
import UIKit

@IBDesignable extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    func setRoundedCorners(withBorderWidth width: CGFloat? = nil, withBorderColor color: UIColor? = nil) {
        self.layer.cornerRadius = self.frame.width / 2
        if let borderWidth = width {
            self.borderWidth = borderWidth
        }
        
        if let borderColor = borderColor {
            self.borderColor = borderColor
        }
        self.layer.masksToBounds = true
    }
}
