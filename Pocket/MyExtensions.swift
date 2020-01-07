import UIKit

extension UIImage {
    
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    /// for Hex color code
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

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

// The pro approach would be to use an extension:
//extension Dictionary {
//
//    public init(keys: [Key], values: [Value]) {
//        precondition(keys.count == values.count)
//
//        self.init()
//
//        for (index, key) in keys.enumerate() {
//            self[key] = values[index]
//        }
//    }
//}

extension UIViewController
{
    func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}


extension Date
{
    
    public enum DateTimeInterval {
        case Day, Week, Month, Year
    }
    
    /// Get start end dates in user's current time zone
    public static func getStartEndDates(timeInterval: DateTimeInterval) -> (String, String) {
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateFormat = "yyyy-MM-dd 00:00"
        startDateFormatter.timeZone = .current // Use user's current time zone
        
        let endDateFormatter = DateFormatter()
        endDateFormatter.dateFormat = "yyyy-MM-dd 23:59"
        endDateFormatter.timeZone = .current // Use user's current time zone

        let dateComponent1: DateComponents? // Used for Month and Year
        var dateComponent2 = DateComponents() // Used for Day and Week
        
        var startDate = Date()
        var endDate: Date?

        switch timeInterval {
        
        case .Day:
            endDate = Calendar.current.date(byAdding: dateComponent2, to: startDate)
            
//            print(dateFormatter.string(from: startDate))
//            print(dateFormatter.string(from: endDate!))
        case .Week:
//            print ("Current Week")
            let gregorian = Calendar(identifier: .gregorian)
            startDate = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
            dateComponent2.day = 6 // 7 days in a week
            endDate = Calendar.current.date(byAdding: dateComponent2, to: startDate)
            
//            print(dateFormatter.string(from: startDate))
//            print(dateFormatter.string(from: endDate!))
            
        case .Month:
//            print ("Current Month")
            dateComponent1 = Calendar.current.dateComponents([.year, .month], from: Date())
            startDate = Calendar.current.date(from: dateComponent1!)!
            dateComponent2.month = 1
            dateComponent2.day = -1
            endDate = Calendar.current.date(byAdding: dateComponent2, to: startDate)
            
//            print(dateFormatter.string(from: startDate))
//            print(dateFormatter.string(from: endDate!))

        case .Year:
//            print ("Current year")
            dateComponent1 = Calendar.current.dateComponents([.year], from: Date())
            startDate = Calendar.current.date(from: dateComponent1!)!
            dateComponent2.year = 1
            dateComponent2.day = -1
            endDate = Calendar.current.date(byAdding: dateComponent2, to: startDate)
            
//            print(dateFormatter.string(from: startDate))
//            print(dateFormatter.string(from: endDate!))
        }
        
        return (startDateFormatter.string(from: startDate), endDateFormatter.string(from: endDate!))
    }
}


extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}
