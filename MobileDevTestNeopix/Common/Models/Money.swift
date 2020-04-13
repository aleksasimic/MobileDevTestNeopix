import Foundation

public enum Currency {
    case usd
}
public struct Money {
    private var amount: Double
    private var currency: Currency
    
    public init(amount: Double, currency: Currency = .usd) {
        self.amount = amount
        self.currency = currency
    }
    
    public var amountWithCurrencySymbol: String {
        let numberFormatter = NumberFormatter.moneyNumberFormatter
        let formattedAmount = numberFormatter.string(from: NSNumber(value: amount)) ?? ""
        
        return "\(currencySymbol)\(formattedAmount)"
    }
    
    private var currencySymbol: String {
        switch currency {
        case .usd:
            return "$"
        }
    }
}


