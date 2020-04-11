import Foundation

public enum OrderStatus: String, Decodable {
    case pending           = "pending"
    case declined          = "declined"
    case accepted          = "accepted"
    case partiallyAccepted = "partially_accepted"
    case unknown           = "unknown"
}
