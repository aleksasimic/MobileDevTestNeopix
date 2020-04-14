import Foundation

public struct MonthAndYearData: Hashable {
    let month: Int
    let year: Int
    let monthAndYearString: String
    
    init(month: Int, year: Int) {
        self.month = month
        self.year = year
        self.monthAndYearString = "\(DateFormatter().monthSymbols[month - 1].uppercased()) \(year)"
    }
}

extension MonthAndYearData: Equatable {}

public func == (lhs: MonthAndYearData, rhs: MonthAndYearData) -> Bool {
    return lhs.month == rhs.month && lhs.year == rhs.year
}

extension MonthAndYearData: Comparable {}

public func < (lhs: MonthAndYearData, rhs: MonthAndYearData) -> Bool {
    if lhs.year < rhs.year {
        return true
    } else {
        return lhs.month < rhs.month
    }
}
