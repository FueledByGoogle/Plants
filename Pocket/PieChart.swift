import Foundation
import UIKit

class Piechart: UIView {
    
    struct PiePiece {
        var name : String
        var amount : CGFloat
        var color : UIColor
    }
    
    override func draw(_ rect: CGRect) {

        // temp variables to test pie chart
        var segments: [PiePiece] = []
        segments.append(PiePiece.init(name: "Entertainment", amount: 25, color: UIColor(rgb: 0xFF2F92)))
        segments.append(PiePiece.init(name: "Food", amount: 50, color: UIColor(rgb: 0x9437FF)))
        segments.append(PiePiece.init(name: "Services", amount: 100, color: UIColor(rgb: 0x76D6FF)))
        
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
        let totalValue = segments.reduce(0, {$0 + $1.amount} )
        
        // note when drawing: whatever is drawn after goes on top of the first
        for i in 0 ..< segments.count {
            let segment = segments[i]
            
            // percentage to determine how much to move by
            let percent = segment.amount/totalValue
            let endAngle = currentAngle + anglePI2 * percent
            
            // define path (shape) of the piece
            ctx?.beginPath()
            ctx?.move(to: viewCenter)
            ctx?.addArc(center: viewCenter, radius: radius, startAngle: currentAngle, endAngle: endAngle, clockwise: false)
            ctx?.closePath()
            
            // fill color of piece
            ctx?.setFillColor(segment.color.cgColor)
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
