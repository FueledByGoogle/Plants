import UIKit

extension UITextField {
    
    func addBottomBorder(cgColor: CGColor, height: CGFloat, width: CGFloat){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: width, height: height)
        bottomLine.backgroundColor = cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
    
    func setupText(text: String, color: UIColor, font: UIFont) {
        self.text = text
        self.textColor = color
        self.font = font
    }
    
    func addCancelDoneButton(target: Any, doneSelector: Selector, cancelSelector: Selector) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: target, action: cancelSelector)
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: doneSelector)
        toolBar.setItems([cancelButton, flexible, doneButton], animated: false)
        self.inputAccessoryView = toolBar
//        toolBar.sizeToFit()
//        toolBar.barStyle = UIBarStyle.default
    }
}
