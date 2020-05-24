import UIKit


class CalendarTVCell: UITableViewCell {
    
    
    // For displaying the name and category
    let expenseLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
//        label.backgroundColor = .red
        return label
    }()
    
    let expenseAmount: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .purple
        label.adjustsFontSizeToFitWidth = true // adjust font to fit text
        return label
    }()
    
    let expenseNotes: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        //        label.backgroundColor = .yellow
        label.numberOfLines = 2
        return label
    }()
    
    var expenseEntryDate = ""
    var expenseCategory = ""
    var expenseDescription = ""
    
    var expenseID = 0
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        self.addSubview(expenseLabel)
        self.addSubview(expenseNotes)
        self.addSubview(expenseAmount)
    }
    
    
    // We must set frame size here because if we set frame size during init the width has not been set yet to be the table view cell width, so we would get an incorrect width and height value
    override func layoutSubviews() {
        expenseLabel.frame = CGRect(x: 5, y: 0, width: self.frame.width*0.8-5, height: self.frame.height*0.4)
        expenseNotes.frame = CGRect(x: 5, y: expenseLabel.frame.maxY, width: self.frame.width*0.8-5, height: self.frame.height*0.6)
        expenseAmount.frame = CGRect(x: expenseNotes.frame.width+5, y: 0, width: self.frame.width*0.2, height: self.frame.height)
        expenseAmount.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
