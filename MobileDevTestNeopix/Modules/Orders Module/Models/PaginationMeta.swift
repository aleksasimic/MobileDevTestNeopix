import Foundation

public struct PaginationMeta {
    let nextId: Int
    let count: Int
    let totalCount: Int
    let totalAmount: Int
}

extension PaginationMeta: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        nextId = try container.decode(Int.self, forKey: .nextId)
        count = try container.decode(Int.self, forKey: .count)
        totalCount = try container.decode(Int.self, forKey: .totalCount)
        totalAmount = try container.decode(Int.self, forKey: .totalAmount)
    }
    
    private enum CodingKeys: String, CodingKey {
        case nextId
        case count
        case totalCount
        case totalAmount
    }
}
