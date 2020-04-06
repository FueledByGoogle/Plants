import Foundation
import UIKit

class UITextFieldDate: UITextField {
    
    
    //TODO: Disable long press menu options
    
    // Disable short press menu options
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
