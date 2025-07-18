import UIKit

public extension UIImageView {

    func setLoaderImage(url: String) {
        Task {
            let result = await KImageLoader.loadImage(with: url)

            if case .success(let image) = result {
                self.image = image
            }
        }
    }

}
