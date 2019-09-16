import UIKit


class PieChart: UIView {
    
    // Array holding category corresponding to its value
    var categories = [String]()
    var values = [CGFloat]()
    var colourMap: [String: Int] = [:]
    
    /** initialize with relevant frame, and reference to user
     */
    init(frame: CGRect, categories: inout [String],  values: inout [CGFloat],  mapping: inout [String : Int]) {
        super.init(frame: frame)
        self.categories =  categories
        self.values = values
        self.colourMap = mapping
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
        
        // we set initial result to be 0, recursively add result with next element
        let totalValue = values.reduce(0, {$0 + $1})
        
        for i in 0 ..< colourMap.count {
            
            // percentage to determine how much to move by
            let percent = values[i]/totalValue
            let endAngle = startAngle + anglePI2 * percent
            
            // define path (shape) of the piece
            ctx?.move(to: viewCenter)
            ctx?.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            
            // fill color of piece
            ctx?.setFillColor(UIColor(rgb: MyEnums.Colours.allCases[i].rawValue).cgColor)
            ctx?.fillPath()
            
            // piece border
//            ctx?.move(to: viewCenter)
//            ctx?.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
//
            // draw line on current path, and colour
//            ctx?.setStrokeColor(UIColor.white.cgColor)
//            ctx?.strokePath()
            
            startAngle = endAngle
        }
    }
}
