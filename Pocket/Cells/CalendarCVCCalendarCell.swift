import UIKit

class CalendarCVCCalendarCell: UICollectionViewCell {
    
    //    let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false // must have
        return label
    }()
    
    var date = 0
//    var date: Date = {
//        var date = Date()
//        return date
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(label)
        label.textAlignment = .center
        
        setUpContraints()
    }
    
    func setUpContraints() {
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override var isHighlighted: Bool {
//        didSet {
//            self.contentView.backgroundColor = isHighlighted ? UIColor(white: 217.0/255.0, alpha: 1.0) : nil
//        }
//    }
}
