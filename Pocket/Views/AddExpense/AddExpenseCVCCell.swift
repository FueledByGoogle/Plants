import UIKit

class AddExpenseCVCCell: UICollectionViewCell {
    
    //    let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(label)
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
}
