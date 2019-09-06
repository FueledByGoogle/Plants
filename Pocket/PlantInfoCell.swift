import UIKit

class PlantInfoCell: UICollectionViewCell {
    
    let sectionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false // must have
//        label.backgroundColor = UIColor.green
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false // must have
        label.font = UIFont.systemFont(ofSize: 16)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
//        label.backgroundColor = UIColor.cyan
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    func setUpView() {
//        backgroundColor = UIColor.yellow
 
        addSubview(sectionLabel)
        addSubview(descriptionLabel)
        
        sectionLabel.textAlignment = .center
        sectionLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sectionLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        sectionLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
 

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
