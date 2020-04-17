import UIKit
import RxSwift

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
    
    
    func showVenueInfo(forVenue venue: Venue) {
        let vc = VenueInfoViewController.instantiate()
        
        vc.modalPresentationStyle = .custom
        
        vc.coordinator = self
        vc.viewModelBuilder = {
            VenueInfoViewModel(venue: Observable.just(venue))
        }
        
        if let presentedViewController = navigationController.presentedViewController {
            presentedViewController.present(vc, animated: true, completion: nil)
        }
    }
    
    func closeVenueInfo() {
        if let orderDetailsVc = navigationController.presentedViewController {
            if let venueInfoVc = orderDetailsVc.presentedViewController {
                venueInfoVc.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func showCancelDeclineOrder() {
        let vc = DeclineOrderViewController.instantiate()
        
        vc.modalPresentationStyle = .custom
        
        vc.coordintor = self
        
        if let presentedViewController = navigationController.presentedViewController {
            presentedViewController.present(vc, animated: true, completion: nil)
        }
    }
    
    func cancelDeclineOrder() {
        if let orderDetailsVc = navigationController.presentedViewController {
            if let declineOrderVc = orderDetailsVc.presentedViewController {
                declineOrderVc.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func declineOrder() {
        if let orderDetailsVc = navigationController.presentedViewController {
            if let declineOrderVc = orderDetailsVc.presentedViewController {
                declineOrderVc.dismiss(animated: true, completion: nil)
            }
            orderDetailsVc.dismiss(animated: true, completion: nil)
        }
    }
}
