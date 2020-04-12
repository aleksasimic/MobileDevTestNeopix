import RxSwift
import RxSwiftExt

typealias OrdersListViewModelBuilder = (_ loadTrigger: Observable<Void>) -> OrdersListViewModel

struct OrdersListViewModel {
    let distributorLogoUrl: Observable<String>
    
    init(loadTrigger: Observable<Void>, service: OrdersNetworkServiceProtocol) {
            
        let distributorResults = loadTrigger
            .flatMapLatest {
                service.getDistributor().materialize()
            }
            .retry(3)
            .share(replay: 3, scope: .whileConnected)
        
        distributorLogoUrl = distributorResults.elements()
            .map { $0.logo }
    }
}
