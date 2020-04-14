import Foundation

extension Date {
    init(fromMilliseconds milliseconds: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    var month: Int {
        get {
            return Calendar.current
                .dateComponents([.month], from: self)
                .month!
        }
    }
    
    var year: Int {
        get {
            return Calendar.current
                .dateComponents([.year], from: self)
                .year!
        }
    }
    
    var monthString: String {
        get {
            return Calendar.current.monthSymbols[month-1]
        }
    }
    
    var monthAndYearString: String {
        return "\(month) \(year)"
    }
}
