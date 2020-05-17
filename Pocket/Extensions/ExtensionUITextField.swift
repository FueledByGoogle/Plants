import UIKit

extension UITextField {
    func addBottomBorder(cgColor: CGColor, height: CGFloat){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: height)
        bottomLine.backgroundColor = cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}
