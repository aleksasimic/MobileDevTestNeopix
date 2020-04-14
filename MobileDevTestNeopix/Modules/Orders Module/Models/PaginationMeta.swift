import Foundation

public struct PaginationMeta {
    let nextId: Int?
    let count: Int
    let totalCount: Int
    let totalAmount: Money
}

extension PaginationMeta: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        nextId = try container.decodeIfPresent(Int.self, forKey: .nextId)
        count = try container.decode(Int.self, forKey: .count)
        totalCount = try container.decode(Int.self, forKey: .totalCount)
        let totalAmountNumber = try container.decode(Double.self, forKey: .totalAmount)
        totalAmount = Money(amount: totalAmountNumber)
    }
    
    private enum CodingKeys: String, CodingKey {
        case nextId
        case count
        case totalCount
        case totalAmount
    }
}
