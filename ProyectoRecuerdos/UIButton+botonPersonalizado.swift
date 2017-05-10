import UIKit

extension UIButton {
    
    func bordesRedondos(radio: Double) {
        layer.cornerRadius = CGFloat(radio / 2)
    }
    
    func buttonToCircle() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
}
