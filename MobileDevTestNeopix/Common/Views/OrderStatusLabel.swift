import Foundation
import UIKit

@IBDesignable
public final class OrderStatusLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 5.0
    @IBInspectable var rightInset: CGFloat = 5.0
    
    override public func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override public var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    func setupViewsForOrderStatus(status: OrderStatus) {
        switch status {
        case .accepted:
            self.backgroundColor = UIColor.orderStatusAcceptedColor()
            self.text = String.Accepted
        case .declined:
            self.backgroundColor = UIColor.orderStatusDeclinedColor()
            self.text = String.Declined
        case .partiallyAccepted:
            self.backgroundColor = UIColor.orderStatusPartiallyAcceptedColor()
            self.text = String.PartiallyAccepted
        case .pending:
            self.backgroundColor = UIColor.orderStatusPendingColor()
            self.text = String.Pending
        default:
            break
        }
    }
}

private extension String {
    static let Accepted          = "ACCEPTED"
    static let PartiallyAccepted = "PARTIALLY ACCEPTED"
    static let Declined          = "DECLINED"
    static let Pending           = "PENDING"
}
