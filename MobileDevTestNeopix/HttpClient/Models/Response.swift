import Foundation

public struct Response {
    public let data: Data
    
    public init() {
        self.data = Data()
    }
    
    public init(_ data: Data) {
        self.data = data
    }
}
