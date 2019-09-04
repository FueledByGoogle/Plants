//
//  PieView.swift
//  Pocket
//
//  Created by Leo Huang on 2019-09-01.
//  Copyright © 2019 Leo Huang. All rights reserved.
//

import Foundation
import UIKit

class PieView: UIView {
    
    struct PiePiece {
        var name : String
        var amount : CGFloat
        var color : UIColor
    }
    
    override func draw(_ rect: CGRect) {
        
        // temp variables to test pie chart
        var segments: [PiePiece] = []
        segments.append(PiePiece.init(name: "Entertainment", amount: 25, color: UIColor.red))
        segments.append(PiePiece.init(name: "Food", amount: 50, color: UIColor.yellow))
        segments.append(PiePiece.init(name: "Services", amount: 100, color: UIColor.blue))
        
        
        
        //  total angle of a circle
        let anglePI2 = (CGFloat.pi * 2)
        // center point of circle
        let viewCenter = CGPoint.init(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        // radius of the pie chart
        let radius = min(self.bounds.size.width, self.bounds.size.height) * 0.5;
        
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
