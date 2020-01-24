import UIKit

class CalendarListCell: UICollectionViewCell {
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .cyan
        return label
    }()
    
    
    var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        self.addSubview(label)
        setUpContraints()
        
    }
    
    
    func setUpContraints()
    {
        label.frame = CGRect(x: 10, y: 0, width: self.frame.width*0.6, height: self.frame.height)
//        totalLabel.frame = CGRect(x: self.frame.width*0.6+10, y: 0, width: self.frame.width*0.4-10-10, height: self.frame.height)
//        totalLabel.textAlignment = .right

        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
