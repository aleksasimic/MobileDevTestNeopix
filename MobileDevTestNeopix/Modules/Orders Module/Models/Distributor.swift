import Foundation

public struct Distributor {
    let id: Int
    let name: String
    let logo: String
    let phone: String
    let email: String
    let caption: String
    let address: String
}

extension Distributor: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        logo = try container.decodeIfPresent(String.self, forKey: .logo) ?? ""
        phone = try container.decodeIfPresent(String.self, forKey: .phone) ?? ""
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        caption = try container.decodeIfPresent(String.self, forKey: .caption) ?? ""
        address = try container.decodeIfPresent(String.self, forKey: .address) ?? ""
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case logo
        case phone
        case email
        case caption
        case address
    }
}
