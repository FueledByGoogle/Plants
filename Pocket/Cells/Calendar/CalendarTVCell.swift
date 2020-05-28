import UIKit


class CalendarTVCell: UITableViewCell {
    
    
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
    
    // For displaying the name and category
    let expenseLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
//        label.backgroundColor = .red
        return label
    }()
    
    var expenseEntryDate = ""
    var expenseCategory = ""
    var expenseDescription = ""
    var databaseID = 0
    var rowID = 0 // Used to set colour of label
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        self.addSubview(expenseLabel)
        self.addSubview(expenseNotes)
        self.addSubview(expenseAmount)
    }
    
    // We must set frame size here because if we set frame size during init the width has not been set yet to be the table view cell width, so we would get an incorrect width and height value
    override func layoutSubviews() {
        let colorBox = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        colorBox.backgroundColor = UIColor(rgb: CategoryEnum.getCategoryColorValue(category: expenseCategory))
        self.addSubview(colorBox)
        
        let margin = CGFloat(15)
        expenseLabel.frame = CGRect(x: margin, y: 0, width: self.frame.width*0.8-margin, height: self.frame.height*0.4)
        expenseNotes.frame = CGRect(x: margin, y: expenseLabel.frame.maxY, width: self.frame.width*0.8-margin, height: self.frame.height*0.6)
        expenseAmount.frame = CGRect(x: expenseNotes.frame.width+margin, y: 0, width: self.frame.width*0.2, height: self.frame.height)
        expenseAmount.textAlignment = .center
        expenseLabel.text = (expenseCategory + ": " + expenseDescription) // For display
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
