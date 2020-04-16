import Foundation
import UIKit

public final class TabIndicatorView: UIView {
    public func setupIndicatorColor(forStatus status: OrderStatus) {
        switch status {
        case .accepted:
            self.backgroundColor = UIColor.orderStatusAcceptedColor()
        case .declined:
            self.backgroundColor = UIColor.orderStatusDeclinedColor()
        case .partiallyAccepted:
            self.backgroundColor = UIColor.orderStatusPartiallyAcceptedColor()
        case .pending:
            self.backgroundColor = UIColor.orderStatusPendingColor()
        default:
            break
        }
    }
}
