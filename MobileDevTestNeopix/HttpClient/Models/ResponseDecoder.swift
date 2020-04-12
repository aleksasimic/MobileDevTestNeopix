import Foundation

public protocol ResponseDecoder {
    associatedtype Result
    static func decode(_ response: Response) throws -> Result
}
