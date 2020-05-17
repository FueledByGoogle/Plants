import UIKit


class CalendarTVCell: UITableViewCell {
    
    let name: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .blue
        label.font = .systemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true // adjust font to fit text
        return label
    }()
    
    let category: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
//        label.backgroundColor = .red
        return label
    }()
    
    let notes: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .yellow
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 2
        return label
    }()
    
    let amount: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .blue
        label.adjustsFontSizeToFitWidth = true // adjust font to fit text
        return label
    }()
    
    var rowId = 0
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(name)
        self.addSubview(category)
        self.addSubview(notes)
        self.addSubview(amount)
    }
    
    // We must set frame size here because if we set frame size during init the width has not been set yet to be the table view cell width, so we would get an incorrect width and height value
    override func layoutSubviews() {
        category.frame = CGRect(x: 5, y: 0, width: self.frame.width*0.30, height: self.frame.height*0.60)
        name.frame = CGRect(x: 5, y: self.frame.height*0.6, width: self.frame.width*0.30, height: self.frame.height*0.4)
        notes.frame = CGRect(x: self.frame.width*0.30, y: 0, width: self.frame.width*0.55, height: self.frame.height)
        amount.frame = CGRect(x: self.frame.width*0.85, y: 0, width: self.frame.width*0.15, height: self.frame.height)
        amount.textAlignment = .center
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
