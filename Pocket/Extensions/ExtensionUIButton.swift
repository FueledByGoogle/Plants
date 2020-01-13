import UIKit

extension UIButton{
    func roundTwoCorners(borderColor: CGColor, lineWidth: CGFloat, cornerRadiiWidth: Int, cornerRadiiHeight: Int, corner1: UIRectCorner, corner2: UIRectCorner){
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: [corner1 , corner2],
                                cornerRadii: CGSize(width: cornerRadiiWidth, height: cornerRadiiHeight))
        // Add rounded corners
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
        
        
        // Add border
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer.path // Reuse the Bezier path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor
        borderLayer.lineWidth = lineWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
    
    
    public enum UIButtonBorderSide {
        case Top, Bottom, Left, Right
    }
    
    public func addBorder(side: UIButtonBorderSide, color: CGColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Top:
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        case .Bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .Right:
            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        }
        
        self.layer.addSublayer(border)
    }
    
}
