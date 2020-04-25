import UIKit


class CalendarTVCell: UITableViewCell {
    
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .red
        // resizes view automatically to fit text
//        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let totalLabel: UILabel = {
        let totalLabel = UILabel()
        totalLabel.textColor = .black
        totalLabel.backgroundColor = .blue
        return totalLabel
    }()
    
    var rowId = 0
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(totalLabel)
        self.addSubview(label)
    }
    
    // We must set frame size here because if we set frame size during init the width has not been set yet to be the table view cell width, so we would get an incorrect width and height value
    override func layoutSubviews() {
        label.frame = CGRect(x: 0, y: 0, width: self.frame.width*0.6, height: self.frame.height)
        totalLabel.frame = CGRect(x: self.frame.width*0.6, y: 0, width: self.frame.width*0.4, height: self.frame.height)
        totalLabel.textAlignment = .right
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
