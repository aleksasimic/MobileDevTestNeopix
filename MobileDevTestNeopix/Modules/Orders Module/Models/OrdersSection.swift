import Foundation

struct OrdersSection {
    var monthAndYearData: MonthAndYearData
    var orders: [Order]
    
    init(monthAndYearData: MonthAndYearData, orders: [Order]) {
        self.monthAndYearData = monthAndYearData
        self.orders = orders
    }
}
