import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func cacheableImage(fromUrl urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                imageCache.setObject(image!, forKey: urlString as AnyObject)
                self.image = UIImage(data: data!)
            }
        }
    }
}
