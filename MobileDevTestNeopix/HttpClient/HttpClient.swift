import Foundation
import RxSwift
import RxCocoa

public struct HttpClient {
    
    private var session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    public func sendRequest(method: HttpMethod, url: URL, body:[String: AnyObject]? = nil , headers: [String: String]? = nil) -> Observable<Response> {
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = method.rawValue
        
        headers?.forEach {
            request.addValue($1, forHTTPHeaderField: $0)
        }
        
        return session.rx.data(request: request as URLRequest)
                 .catchError { return Observable.error($0) }
                 .map { Response($0) }
     }
}
