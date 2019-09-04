//
//  DataCell.swift
//  Plants
//
//  Created by Leo Huang on 2018-07-17.
//  Copyright © 2018 Leo Huang. All rights reserved.
//

import UIKit

class SearchCell: UICollectionViewCell {
    
    public var labelId = 0
    
    //    let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false // must have
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        setUpContraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        addSubview(nameLabel)
        nameLabel.textAlignment = .center
    }
    
    func setUpContraints() {
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
}
