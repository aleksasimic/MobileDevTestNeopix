import Foundation

public struct DistributorDecoder: ResponseDecoder {
    public static func decode(_ response: Response) throws -> Distributor {
        let decoder = try JSONDecoder().decode(DistributorDecodable.self, from: response.data)
        return decoder.distributor
    }
    
    private struct DistributorDecodable: Decodable {
        var distributor: Distributor
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: RootKeys.self)
            distributor = try container.decode(Distributor.self, forKey: .data)
        }
        
        enum RootKeys: String, CodingKey {
            case data
        }
    }
}
