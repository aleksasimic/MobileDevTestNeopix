import UIKit

class OrderTableViewCell: UITableViewCell {
    
    static let identifier = "OrderCell"

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var orderedDateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: OrderStatusLabel!
    
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
        orderStatusLabel.setupViewsForOrderStatus(status: order.orderStatus)
    }
}
