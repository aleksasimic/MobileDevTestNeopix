import RxSwift
import RxSwiftExt

typealias OrderDetailsViewModelBuilder = (_ loadTrigger: Observable<Void>) -> OrderDetailsViewModel

struct OrderDetailsViewModel {
    let order: Observable<Order>
    
    init(loadTrigger: Observable<Void>, orderId: Int, service: OrdersNetworkServiceProtocol) {
        
        let orderDetailResults = loadTrigger
            .flatMapLatest {
                service.getOrderDetails(withOrderId: orderId).materialize()
            }
            .retry(3)
            .share(replay: 1, scope: .whileConnected)
        
        let orderDetailsData = orderDetailResults.elements()
        
        order = orderDetailsData
            .map {
                $0
            }
    }
}
