import UIKit

final class OrdersCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    public init(withNavigationController navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = OrdersViewController.instantiate()
        navigationController.pushViewController(vc, animated: true)
    }
}

extension OrdersCoordinator: Orderable {
    func showOrderDetails() {
        //NOTE: TO BE IMPLEMENTED
    }
}
