import Foundation
import RxSwift

protocol OrdersNetworkServiceProtocol {
    func getDistributor() -> Observable<Distributor>
    func getOrders(nextId: Int?, limit: Int?) -> Observable<([Order], PaginationMeta)>
    func getOrderDetails(withOrderId orderId: Int) -> Observable<Order>
}

//extension OrdersNetworkServiceProtocol {
//    func getOrders(nextId: Int? = nil, limit: Int? = nil) -> Observable<([Order], PaginationMeta)> {
//        return getOrders(nextId: nextId, limit: limit)
//    }
//}

struct OrdersNetworkService: OrdersNetworkServiceProtocol {
    private let httpClient: HttpClient
    private let baseApiUrl: String
    
    init(httpClient: HttpClient, baseApiUrl: String) {
        self.httpClient = httpClient
        self.baseApiUrl = baseApiUrl
    }
    
    func getDistributor() -> Observable<Distributor> {
        let url = URL.url(withPath: Endpoints.Distributor, relativeTo: baseApiUrl)
        
        return httpClient.sendRequest(method: .Get, url: url)
            .map(DistributorDecoder.decode)
    }
    
    func getOrders(nextId: Int? = nil, limit: Int? = nil) -> Observable<([Order], PaginationMeta)> {
        var queryParameters: [String: String] = [:]
      
        if let id = nextId {
            queryParameters[Parameters.NextId] = "\(id)"
        }
        
        if let ordersLimit = limit {
            queryParameters[Parameters.Limit] = "\(ordersLimit)"
        }
   
        let url = URL.url(withPath: Endpoints.OrderList, relativeTo: baseApiUrl).urlByAppendingQueryParameters(queryParameters)
        
        return httpClient.sendRequest(method: .Get, url: url)
            .map(OrdersDecoder.decode)
    }
    
    func getOrderDetails(withOrderId orderId: Int) -> Observable<Order> {
        let url = URL.url(withPath: Endpoints.orderDetails(withId: orderId), relativeTo: baseApiUrl)
        
        return httpClient.sendRequest(method: .Get, url: url)
            .map(OrderDetailsDecoder.decode)
    }
}

private struct Endpoints {
    static let Distributor  = "/me"
    static let OrderList    = "/orders"
    
    static func orderDetails(withId id: Int) -> String {
        return "\(OrderList)/\(id)"
    }
}

private struct Parameters {
    static let NextId = "nextId"
    static let Limit  = "limit"
}

