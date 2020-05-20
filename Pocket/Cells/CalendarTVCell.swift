import UIKit


class CalendarTVCell: UITableViewCell {
    
    let categoryAndName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
//        label.backgroundColor = .red
        return label
    }()
    
    let notes: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        //        label.backgroundColor = .yellow
        label.numberOfLines = 2
        return label
    }()
    
    let amount: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .purple
        label.adjustsFontSizeToFitWidth = true // adjust font to fit text
        return label
    }()
    
    var rowId = 0
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.addSubview(categoryAndName)
        self.addSubview(notes)
        self.addSubview(amount)
    }
    
    // We must set frame size here because if we set frame size during init the width has not been set yet to be the table view cell width, so we would get an incorrect width and height value
    override func layoutSubviews() {
        categoryAndName.frame = CGRect(x: 5, y: 0, width: self.frame.width*0.8-5, height: self.frame.height*0.4)
        notes.frame = CGRect(x: 5, y: categoryAndName.frame.maxY, width: self.frame.width*0.8-5, height: self.frame.height*0.6)
        amount.frame = CGRect(x: notes.frame.width+5, y: 0, width: self.frame.width*0.2, height: self.frame.height)
        amount.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
