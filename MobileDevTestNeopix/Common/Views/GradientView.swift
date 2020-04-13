import Foundation
import UIKit

@IBDesignable
public final class GradientView: UIView {
    @IBInspectable public var startPoint: CGPoint = CGPoint(x: 0.5, y: 0) {
        didSet {
            updateLayer()
        }
    }
    @IBInspectable public var endPoint: CGPoint = CGPoint(x: 0.5, y: 1) {
        didSet {
            updateLayer()
        }
    }
    @IBInspectable public var startColor: UIColor = UIColor.white {
        didSet {
            updateLayer()
        }
    }
    @IBInspectable public var endColor: UIColor = UIColor.white {
        didSet {
            updateLayer()
        }
    }

    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override public func awakeFromNib() {
        updateLayer()
    }

    public func updateLayer() {
        guard let gradientLayer = self.layer as? CAGradientLayer else {
            fatalError("Error")
        }
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
    }
}
