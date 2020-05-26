import Foundation
import UIKit

class UITextFieldNoMenu: UITextField {
    
    // Disable short press menu options
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
