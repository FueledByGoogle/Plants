//
//  CalendarView.swift
//  Pocket
//
//  Created by Leo Huang on 2020-01-24.
//  Copyright © 2020 Leo Huang. All rights reserved.
//

import UIKit


class CalendarView: UIViewController {
    
    var calendarCVCView: CalendarCVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: MyEnums.Colours.ORANGE_Dark.rawValue)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationItem.title = MyEnums.TabNames.Calendar.rawValue
        self.view.backgroundColor = .black
        
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        calendarCVCView = CalendarCVC(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), collectionViewLayout: layout)
        calendarCVCView!.viewDidLoad()
        calendarCVCView!.setCollectionViewLayout(layout, animated: false)
        
        self.view.addSubview(calendarCVCView!)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        calendarCVCView?.viewDidAppear(true)
    }
}
