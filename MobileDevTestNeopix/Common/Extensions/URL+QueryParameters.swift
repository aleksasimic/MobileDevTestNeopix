import Foundation

public extension URL {
    func urlByAppendingQueryParameters(_ params: [String: String]?) -> URL {
        guard let params = params, var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }
        
        components.queryItems = params.map { return URLQueryItem(name: $0.0, value: $0.1) }
        
        if let url = components.url {
            print(url.absoluteString)
            return url
        }
        
        return self
    }
}
