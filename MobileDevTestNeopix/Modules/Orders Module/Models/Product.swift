import Foundation

public struct Product {
    let id: Int
    let name: String
    let imageUrl: String
    let price: String
    let quantity: Int
    let totalPrice: Int
}

extension Product: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        price = try container.decode(String.self, forKey: .price)
        quantity = try container.decode(Int.self, forKey: .quantity)
        totalPrice = try container.decode(Int.self, forKey: .totalPrice)
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
