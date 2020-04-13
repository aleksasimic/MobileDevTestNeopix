import Foundation
import UIKit

extension UIImageView {
    func downloaded(fromUrl url: String) {
        guard let url = URL(string: url) else { return }
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
    }
}
