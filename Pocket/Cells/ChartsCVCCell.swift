import UIKit

class ChartsCVCCell: UICollectionViewCell {
    
    
    let label = UILabel()
    let totalLabel = UILabel()
    
    
    var percentage = 0
    var indexPathNum = 0
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setUpDefaultColors()
        setUpContraints()
    }
    
    /// Add label views [Call this AFTER setting indexPathNum and percentage variables]
    func addViewsWithUpdatedProperties()
    {
        label.textColor = UIColor(rgb: CategoryColourEnum.Colours.allCases[indexPathNum].rawValue)
        
        self.addSubview(totalLabel)
        self.addSubview(label)
    }
    
    
    func setUpDefaultColors()
    {
        if #available(iOS 13.0, *) { // Colors
            totalLabel.textColor = UIColor.label
        } else {
            // Fallback on earlier versions
        }
        
        self.backgroundColor = .clear
    }
    
    
    func setUpContraints()
    {
        label.frame = CGRect(x: 10, y: 0, width: self.frame.width*0.6, height: self.frame.height)
        totalLabel.frame = CGRect(x: self.frame.width*0.6+10, y: 0, width: self.frame.width*0.4-10-10, height: self.frame.height)
        totalLabel.textAlignment = .right

        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//        let circleRadius =  self.frame.height*0.1
//        let circlePath = UIBezierPath(arcCenter: CGPoint(x: circleRadius*2, y: self.frame.height/2), radius: circleRadius, startAngle: 0, endAngle: CGFloat(Float.pi*2), clockwise: true)
//        let circleLabel = CAShapeLayer()
//        circleLabel.path = circlePath.cgPath
        
        
        // fill in circles
        // because our dictionary mapping is in order we can simply iterate through the index, hence the reason of needing to offset by subtracting 1
//        if indexPath.row < MyEnums.Colours.allCases.count {
//            circleLabel.fillColor = UIColor(rgb: MyEnums.Colours.allCases[indexPath.row].rawValue).cgColor
//        } else {
//            print("not enough colours, grey will be used to reprersent the rest of the colours")
//            circleLabel.fillColor = UIColor(rgb: 0x454545).cgColor
//        }
