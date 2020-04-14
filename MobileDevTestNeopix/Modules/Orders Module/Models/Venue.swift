import Foundation

public struct Venue {
    let id: Int
    let name: String
    let logoUrl: String
    let primaryContactName: String?
    let primaryContactPhone: String?
    let secondaryContactName: String?
    let secondaryContactPhone: String?
    let address: String?
}

extension Venue: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        logoUrl = try container.decode(String.self, forKey: .logoUrl)
        
        primaryContactName = try container.decodeIfPresent(String.self, forKey: .primaryContactName)
        primaryContactPhone = try container.decodeIfPresent(String.self, forKey: .primaryContactPhone)
        secondaryContactName = try container.decodeIfPresent(String.self, forKey: .secondaryContactName)
        secondaryContactPhone = try container.decodeIfPresent(String.self, forKey: .secondaryContactPhone)
        address = try container.decodeIfPresent(String.self, forKey: .address)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case logoUrl = "logo"
        case primaryContactName
        case primaryContactPhone
        case secondaryContactName
        case secondaryContactPhone
        case address
    }
}
