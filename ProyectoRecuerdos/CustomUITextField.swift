import Foundation
import UIKit

class CustomUITextField: UITextField {
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
            return false
        }
        
        return true
    }
    
}
