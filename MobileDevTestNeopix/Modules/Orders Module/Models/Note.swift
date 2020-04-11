import Foundation

public struct Note {
    let noteMessage: String
    let noteDate: Date
}

extension Note: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        noteMessage = try container.decode(String.self, forKey: .noteMessage)
        
        let noteDateInMilliseconds = try container.decode(Int.self, forKey: .noteDate)
        
        noteDate = Date(fromMilliseconds: noteDateInMilliseconds)
    }
    
    private enum CodingKeys: String, CodingKey {
        case noteMessage = "message"
        case noteDate    = "date"
    }
}
