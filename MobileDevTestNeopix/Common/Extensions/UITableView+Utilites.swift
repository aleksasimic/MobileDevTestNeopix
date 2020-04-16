import Foundation
import UIKit

extension UITableView {
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.tableFooterView = UIView()
        
    }
}
