import UIKit

extension UIImageView {
    
    func imageToCircle() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
}
