import Foundation

protocol OrdersContainerProtocol {
    var service: OrdersNetworkServiceProtocol { get }
}

public final class OrdersContainer: OrdersContainerProtocol {
    let baseApiUrl: String
    let httpClient: HttpClient
    
    lazy var service: OrdersNetworkServiceProtocol = {
        return OrdersNetworkService(httpClient: self.httpClient, baseApiUrl: self.baseApiUrl)
    }()
    
    public init(baseApiUrl: String, httpClient: HttpClient) {
        self.baseApiUrl = baseApiUrl
        self.httpClient = httpClient
    }
}
