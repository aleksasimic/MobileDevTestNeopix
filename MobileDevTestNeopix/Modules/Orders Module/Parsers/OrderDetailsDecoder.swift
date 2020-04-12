import Foundation

public struct OrderDetailsDecoder: ResponseDecoder {
    
    public static func decode(_ response: Response) throws -> Order {
        let decoder = try JSONDecoder().decode(OrderDetailsDecodable.self, from: response.data)
        
        return decoder.order
    }
    
    private struct OrderDetailsDecodable: Decodable {
        var order: Order
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: RootKeys.self)
            order = try container.decode(Order.self, forKey: .data)
        }
        
        enum RootKeys: String, CodingKey {
            case data
        }
    }
}
