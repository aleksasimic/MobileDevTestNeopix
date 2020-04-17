import UIKit

class VenueInfoViewController: UIViewController, Storyboarded {
    
    static var storyboardName = "Orders"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
}
