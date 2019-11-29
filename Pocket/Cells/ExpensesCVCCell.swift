import UIKit

class ExpensesCVCCell: UICollectionViewCell {
    
    
    //    let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    let label: UILabel = {
        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false // must have
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(label)
        setUpContraints()
        
        
        // for furture if I find a way to draw bezierpaths in custom cells
         
        // draw and position circles
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
    }
    
    
    func setUpContraints() {
        label.frame = CGRect(x: self.frame.height*0.1*4, y: 0, width: self.frame.width, height: self.frame.height)
        
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
