import Foundation

public struct OrdersDecoder: ResponseDecoder {
    
    public static func decode(_ response: Response) throws -> ([Order], PaginationMeta) {
        let decoder = try JSONDecoder().decode(OrdersDecodable.self, from: response.data)
        
        return (decoder.orders, decoder.paginationMeta)
    }
    
    private struct OrdersDecodable: Decodable {
        var orders:  [Order]
        var paginationMeta: PaginationMeta
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: RootKeys.self)
            orders = try container.decode([Order].self, forKey: .data)
            paginationMeta = try container.decode(PaginationMeta.self, forKey: .meta)
        }
        
        enum RootKeys: String, CodingKey {
             case data
             case meta
         }
    }
}
