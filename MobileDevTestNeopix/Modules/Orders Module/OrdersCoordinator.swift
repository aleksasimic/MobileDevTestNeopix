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
        vc.viewModelBuilder = { loadTrigger, fetchMoreOrdersTrigger in
            OrdersListViewModel(loadTrigger: loadTrigger,
                                fetchMoreOrdersTrigger: fetchMoreOrdersTrigger,
                                service: self.container.service)
        }
        navigationController.pushViewController(vc, animated: true)
    }
}

extension OrdersCoordinator: Orderable {
    func showOrderDetails(withOrderId id: Int, distributorName: String, distributorLogoUrl: String) {
        let vc = OrderDetailsViewController.instantiate()
        vc.coordinator = self
        vc.viewModelBuilder = { loadTrigger in
            OrderDetailsViewModel(loadTrigger: loadTrigger,
                                  orderId: id,
                                  distributorName: distributorName,
                                  distributorLogoUrl: distributorLogoUrl,
                                  service: self.container.service)
        }
        vc.modalPresentationStyle = .overFullScreen
        
        DispatchQueue.main.async {
            self.navigationController.present(vc, animated: true, completion: nil)
        }
    }
    
    func closeOrderDetails() {
        if let presentedViewController = navigationController.presentedViewController {
            presentedViewController.dismiss(animated: true, completion: nil)
        }
    }
}
