import Foundation

public struct Order {
    let id: Int
    let orderNumber: String
    let orderStatus: OrderStatus
    let orderedAt: Date
    var acceptedAt: Date? = nil
    var declinedAt: Date? = nil
    let amount: Int?
    let totalAmount: Int?
    let venue: Venue
    let productList: [Product]?
}

extension Order: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        orderNumber = try container.decode(String.self, forKey: .orderNumber)
        let orderStatusString = try container.decode(String.self, forKey: .orderStatus)
        orderStatus = OrderStatus(rawValue: orderStatusString) ?? .unknown
        
        let orderedAtInMilliseconds = try container.decode(Int.self, forKey: .orderedAt)
        orderedAt = Date(fromMilliseconds: orderedAtInMilliseconds)
        
        let acceptedAtInMilliseconds = try container.decodeIfPresent(Int.self, forKey: .acceptedAt)
        if let accepted = acceptedAtInMilliseconds {
            acceptedAt = Date(fromMilliseconds: accepted)
        }
        
        let declinedInMilliseconds = try container.decodeIfPresent(Int.self, forKey: .declinedAt)
        if let declined = declinedInMilliseconds {
            declinedAt = Date(fromMilliseconds: declined)
        }
        
        amount = try container.decodeIfPresent(Int.self, forKey: .amount)
        totalAmount = try container.decodeIfPresent(Int.self, forKey: .totalAmount)
        venue = try container.decode(Venue.self, forKey: .venue)
        productList = try container.decodeIfPresent([Product].self, forKey: .productList)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case orderNumber
        case orderStatus = "status"
        case orderedAt
        case acceptedAt
        case declinedAt
        case amount
        case totalAmount
        case venue
        case productList = "orderedProducts"
    }
}
