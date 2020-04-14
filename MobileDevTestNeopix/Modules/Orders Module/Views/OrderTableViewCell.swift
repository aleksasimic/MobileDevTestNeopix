import UIKit

class OrderTableViewCell: UITableViewCell {
    
    static let identifier = "OrderCell"

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var orderedDateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(withOrder order: Order) {
        self.venueNameLabel.text = order.venue.name
        let dateFormatter = DateFormatter.customDateFormatter
        self.orderedDateLabel.text = dateFormatter.string(from: order.orderedAt)
        if let amount = order.amount {
            self.amountLabel.text = amount.amountWithCurrencySymbol
        }
        logoImageView.cacheableImage(fromUrl: order.venue.logoUrl)
        
        setupViewsForOrderStatus(status: order.orderStatus)
    }
    
    func setupViewsForOrderStatus(status: OrderStatus) {
        switch status {
        case .accepted:
            orderStatusLabel.backgroundColor = UIColor.orderStatusAcceptedColor()
            orderStatusLabel.text = String.Accepted
        case .declined:
            orderStatusLabel.backgroundColor = UIColor.orderStatusDeclinedColor()
            orderStatusLabel.text = String.Declined
        case .partiallyAccepted:
            orderStatusLabel.backgroundColor = UIColor.orderStatusPartiallyAcceptedColor()
            orderStatusLabel.text = String.PartiallyAccepted
        case .pending:
            orderStatusLabel.backgroundColor = UIColor.orderStatusPendingColor()
            orderStatusLabel.text = String.Pending
        default:
            break
        }
    }
}

private extension String {
    static let Accepted           = "ACCEPTED"
    static let PartiallyAccepted = "PARTIALLY ACCEPTED"
    static let Declined          = "DECLINED"
    static let Pending           = "PENDING"
}
