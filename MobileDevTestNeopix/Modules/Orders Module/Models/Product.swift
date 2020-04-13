import Foundation

public struct Product {
    let id: Int
    let name: String
    let imageUrl: String
    let price: String
    let quantity: Int
    let totalPrice: Money
}

extension Product: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        price = try container.decode(String.self, forKey: .price)
        quantity = try container.decode(Int.self, forKey: .quantity)
        let totalPriceNumber = try container.decode(Double.self, forKey: .totalPrice)
        totalPrice = Money(amount: totalPriceNumber)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrl = "image"
        case price
        case quantity
        case totalPrice
    }
}
