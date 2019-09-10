import Foundation
import UIKit


/* TODO:
 - Possibly map category to a number, this way, piechart can be used
 regardless category names
 */

class Piechart: UIView {
    
    // Array holding category corresponding to its value
    var categories = [String]()
    var values = [CGFloat]()
    
    /** initialize with relevant frame, and reference to user
     */
    init(frame: CGRect, categories: inout [String],  values: inout [CGFloat]) {
        super.init(frame: frame)
        self.categories =  categories
        self.values = values
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let pieChartSizeReduction  = CGFloat(0.40)
        
        //  total angle of a circle
        let anglePI2 = (CGFloat.pi * 2)
        // radius of the pie chart
        let radius = min(bounds.size.width, bounds.size.height) * pieChartSizeReduction;
        
        // center point of circle
        let viewCenter = CGPoint.init(x: bounds.size.width/2, y: bounds.size.height/2)
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setLineWidth(2) // width of future lines that are drawn
        
        // starting angle
        var currentAngle  = CGFloat.init()
        
        // we set initial result to be 0, recursively add result with next element
        let totalValue = values.reduce(0, {$0 + $1})
        
        
        for i in 0 ..< self.categories.count {
            
            // percentage to determine how much to move by
            let percent = values[i]/totalValue
            let endAngle = currentAngle + anglePI2 * percent
            
            // define path (shape) of the piece
            ctx?.beginPath()
            ctx?.move(to: viewCenter)
            ctx?.addArc(center: viewCenter, radius: radius, startAngle: currentAngle, endAngle: endAngle, clockwise: false)
            ctx?.closePath()
            
            // fill color of piece
            switch categories[i] {
            case MyEnums.Categories.Transportation.rawValue :
                ctx?.setFillColor(UIColor(rgb: 0xFF2F92).cgColor)
            case MyEnums.Categories.Food.rawValue :
                ctx?.setFillColor(UIColor(rgb: 0x9437FF).cgColor)
            case MyEnums.Categories.Entertainment.rawValue :
                ctx?.setFillColor(UIColor(rgb: 0x76D6FF).cgColor)
            default:
                print("Category not in Enum, or incorrectly formatted. Setting colour to black.")
                ctx?.setFillColor(UIColor.black.cgColor)
            }
            ctx?.fillPath()
            
            // piece border
            ctx?.beginPath()
            ctx?.move(to: viewCenter)
            ctx?.addArc(center: viewCenter, radius: radius, startAngle: currentAngle, endAngle: endAngle, clockwise: false)
            ctx?.closePath()
            
            // draw line on current path, and colour
            ctx?.setStrokeColor(UIColor.white.cgColor)
            ctx?.strokePath()
            
            currentAngle = endAngle
        }
        
    }
    
}
