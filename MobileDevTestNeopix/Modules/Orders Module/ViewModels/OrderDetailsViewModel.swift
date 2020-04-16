import RxSwift
import RxSwiftExt

typealias OrderDetailsViewModelBuilder = (_ loadTrigger: Observable<Void>) -> OrderDetailsViewModel

struct OrderDetailsViewModel {
    let distributorName: Observable<String>
    let distributorLogoUrl: Observable<String>
    
    let venueName: Observable<String>
    let venueImageUrl: Observable<String>
    let orderStatus: Observable<OrderStatus>
    let orderNumber: Observable<String>
    let orderedAt: Observable<Date>
    let acceptedOrDeclinedAt: Observable<Date>
    let totalAmount: Observable<Money>
    let hideAcceptButton: Observable<Bool>
    
    let products: Observable<[Product]>
    let notes: Observable<[Note]>
    let hideEmptyNotesView: Observable<Bool>
    
    init(loadTrigger: Observable<Void>,
         orderId: Int, distributorName: String, distributorLogoUrl: String,
         service: OrdersNetworkServiceProtocol) {
        
        self.distributorName = Observable.just(distributorName)
        
        self.distributorLogoUrl = Observable.just(distributorLogoUrl)
        
        let orderDetailResults = loadTrigger
            .flatMapLatest {
                service.getOrderDetails(withOrderId: orderId).materialize()
            }
            .retry(3)
            .share(replay: 1, scope: .whileConnected)
        
        let orderDetailsData = orderDetailResults.elements()
        
        let order = orderDetailsData
            .map {
                $0
            }
        
        venueName = order
            .map {
                $0.venue.name
            }
        
        venueImageUrl = order
            .map {
                $0.venue.logoUrl
            }
        
        orderStatus = order
            .map {
                $0.orderStatus
            }
        
        orderNumber = order
            .map {
                $0.orderNumber
            }
        
        orderedAt = order
            .map {
                $0.orderedAt
            }
        
        let acceptedAt = order
            .filter {
                $0.acceptedAt != nil
            }
            .map {
                $0.acceptedAt!
            }
        
        let declinedAt = order
            .filter {
                $0.declinedAt != nil
            }
            .map {
                $0.declinedAt!
            }
        
        acceptedOrDeclinedAt = Observable.of(acceptedAt, declinedAt).merge()
        
        totalAmount = order
            .filter {
                $0.totalAmount != nil
            }
            .map {
                $0.totalAmount!
            }
        
        hideAcceptButton = order
            .map {
                $0.orderStatus != .pending
            }
        
        products = order
            .map {
                $0.productList
            }
        
        notes = order
            .map {
                $0.notesList
            }
        
        hideEmptyNotesView = notes
            .map {
                $0.count > 0
            }
    }
}

private extension String {
    static let NA = "N/A"
}
