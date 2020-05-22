import UIKit

extension UITableViewCell {
    func addBottomBorder(cgColor: CGColor, height: CGFloat, width: CGFloat){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: width, height: height)
        bottomLine.backgroundColor = cgColor
        layer.addSublayer(bottomLine)
    }
}
