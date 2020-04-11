import Foundation

extension Date {
    init(fromMilliseconds milliseconds: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
