import UIKit

class NoteTableViewCell: UITableViewCell {
    
    static let identifier = "NoteCell"

    @IBOutlet weak var distributorImage: UIImageView!
    @IBOutlet weak var distributorNameLabel: UILabel!
    @IBOutlet weak var noteDescriptionLabel: UILabel!
    @IBOutlet weak var noteDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
