import UIKit

class ProductTableViewCell: UITableViewCell {
    
    static let identifier = "ProductCell"

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productQuantityDescriptionLabel: UILabel!
    @IBOutlet weak var productQuantityValueLabel: UILabel!
    @IBOutlet weak var productTotalAmountValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(withProduct product: Product) {
        productImage.cacheableImage(fromUrl: product.imageUrl)
        productNameLabel.text = product.name
        productQuantityValueLabel.text = "\(product.quantity)"
        productTotalAmountValueLabel.text = product.totalPrice.amountWithCurrencySymbol
    }

}
