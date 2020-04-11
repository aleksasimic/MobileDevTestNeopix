import UIKit

class OrdersViewController: UIViewController, Storyboarded {
    static var storyboardName = "Orders"
    
    var coordinator: Orderable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
