import RxSwift
import RxSwiftExt

typealias OrdersListViewModelBuilder = (_ loadTrigger: Observable<Void>, _ fetchMoreOrdersTrigger: Observable<Void>) -> OrdersListViewModel

struct OrdersListViewModel {
    let distributorLogoUrl: Observable<String>
    let distributorData: Observable<(String, String)>
    let totalAmountString: Observable<String>
    let ordersWithSections: Observable<[OrdersSection]>
    
    let error: Observable<Error>
    
    let nextIdPublisher = PublishSubject<Int?>()
    
    init(loadTrigger: Observable<Void>, fetchMoreOrdersTrigger: Observable<Void>, service: OrdersNetworkServiceProtocol) {
        
        let nextPublisher = nextIdPublisher
        
        let distributorResults = loadTrigger
            .flatMapLatest {
                service.getDistributor().materialize()
            }
            .retry(3)
            .share(replay: 3, scope: .whileConnected)
        
        let distributorResultsData = distributorResults.elements()
        
        distributorLogoUrl = distributorResultsData
            .map {
                $0.logo
            }
        
        let distributorName = distributorResultsData
            .map {
                $0.name
            }
        
        distributorData = Observable.combineLatest(distributorLogoUrl, distributorName)
        
        let initalOrderResults = loadTrigger
            .flatMapLatest {
                service.getOrders(nextId: nil, limit: nil).materialize()
            }
            .retry(3)
            .share(replay: 3, scope: .whileConnected)
        
        let initialOrderResultsData = initalOrderResults.elements()
        
        let initialOrders = initialOrderResultsData
            .map {
                $0.0
            }
        
        let fetchMoreOrdersResult = fetchMoreOrdersTrigger
            .withLatestFrom(nextPublisher)
            .filter { $0 != nil }
            .flatMapLatest {
                service.getOrders(nextId: $0, limit: nil).materialize()
            }
            .retry(3)
            .share(replay: 3, scope: .whileConnected)
        
        let fetchMoreOrdersData = fetchMoreOrdersResult.elements()
        
        let moreOrders = fetchMoreOrdersData
            .map {
                $0.0
            }
        
        let combinedNextIds = Observable.of(initialOrderResultsData.map { $0.1.nextId },
                                            fetchMoreOrdersData.map { $0.1.nextId }).merge()
        
        _ = combinedNextIds
            .do(onNext: {
                nextPublisher.onNext($0)
            }).subscribe()
        
        let orders = Observable.of(initialOrders, moreOrders).merge()
            .scan([]) {
                $0 + $1
            }
        
        ordersWithSections = orders.mapToSectionOrders()
        
        let initalOrdersTotalAmount = initialOrderResultsData
            .map {
                $0.1.totalAmount
            }
        
        let moreOrdersTotalAmount = fetchMoreOrdersData
            .map {
                $0.1.totalAmount
            }
        
        totalAmountString = Observable.of(initalOrdersTotalAmount, moreOrdersTotalAmount).merge()
            .map {
                $0.amountWithCurrencySymbol
            }
        
        error = Observable.of(initalOrderResults.errors(), fetchMoreOrdersResult.errors(), distributorResults.errors()).merge()
    }
}

private extension ObservableType where Element == [Order] {
    func mapToSectionOrders() -> Observable<[OrdersSection]> {
        return map { orders in
            let dictionary = Dictionary(grouping: orders, by:  { $0.monthAndYear })
            let sortedKeys = dictionary.keys.sorted(by: {$0.month > $1.month})
            var sectionOrders: [OrdersSection] = []
            for key in sortedKeys {
                sectionOrders.append(OrdersSection(monthAndYearData: key, orders: dictionary[key] ?? []))
            }
            return sectionOrders
        }
    }
}
