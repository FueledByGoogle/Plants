import UIKit

class CalendarTVCell: UITableViewCell {
    
    
    let label = UILabel()
    
    var percentage = 0
    var indexPathNum = 0
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpDefaultColors()
        setUpContraints()
        addViews()
    }
    
    
    func addViews()
    {
        self.addSubview(label)
    }
    
    
    func setUpDefaultColors()
    {
        label.textColor = .black
        label.backgroundColor = .red
//        label.backgroundColor = .white
//        self.backgroundColor = .clear
        
    }
    
    
    func setUpContraints()
    {
//        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 0, width: self.frame.width*0.6, height: self.frame.height)

        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
