import UIKit


class PieChart: UIView {
    
    // Array holding category corresponding to its value
    var categories: [String: CGFloat] = [:]
    
    /** catgegories : unique array of categories
        values : total value of each category
     */
    init(frame: CGRect, categories: [String: CGFloat]) {
        super.init(frame: frame)
        self.categories =  categories
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let pieChartSizeReduction  = CGFloat(0.35)
        
        //  angle of a complete circle
        let anglePI2 = (CGFloat.pi * 2)
        // radius of the pie chart
        let radius = min(bounds.size.width, bounds.size.height) * pieChartSizeReduction;
        
        // center point of circle
        let viewCenter = CGPoint.init(x: bounds.size.width/2, y: bounds.size.height/2)
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setLineWidth(1) // width of future lines that are drawn
        
        // starting angle
        var startAngle  = -CGFloat.pi * 0.5
        
        // could be more efficient to add up totals before passing, but since there won't be many categories the run time difference will be negligible.
        var totalValue = CGFloat(0)
        for (_, value) in categories {
            totalValue += value
        }
        
        var i = 0
        for (_, value) in categories {
            // percentage to determine how much to move by
            let percent = value/totalValue
            let endAngle = startAngle + anglePI2 * percent
            
            // define path (shape) of the piece
            ctx?.move(to: viewCenter)
            ctx?.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            
            // fill color of piece
            if i < MyEnums.Colours.allCases.count {
                ctx?.setFillColor(UIColor(rgb: MyEnums.Colours.allCases[i].rawValue).cgColor)
            } else {
                print("not enough colours, grey will be used to reprersent the rest of the colours")
                ctx?.setFillColor(UIColor(rgb: 0x454545).cgColor)
            }
            ctx?.fillPath()
            
            
            // piece border
//            ctx?.move(to: viewCenter)
//            ctx?.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
//
            // draw line on current path, and colour
//            ctx?.setStrokeColor(UIColor.white.cgColor)
//            ctx?.strokePath()
            i += 1
            startAngle = endAngle
        }
    }
}
