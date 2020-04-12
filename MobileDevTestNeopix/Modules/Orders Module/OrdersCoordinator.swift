import UIKit

final class OrdersCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    var container: OrdersContainer
    
    public init(withNavigationController navigationController: UINavigationController, container: OrdersContainer) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        let vc = OrdersListViewController.instantiate()
        vc.coordinator = self
        vc.viewModelBuilder = { loadTrigger in
            OrdersListViewModel(loadTrigger: loadTrigger, service: self.container.service)
        }
        navigationController.pushViewController(vc, animated: true)
    }
}

extension OrdersCoordinator: Orderable {
    func showOrderDetails() {
        //NOTE: TO BE IMPLEMENTED
    }
}
