//
//  Menu.swift
//  Pocket
//
//  Created by Leo Huang on 2019-01-05.
//  Copyright © 2019 Leo Huang. All rights reserved.

import UIKit

class TabBar: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        
        let calendarView = CalendarView()
        let calendarViewController = UINavigationController(rootViewController: calendarView)
        calendarViewController.tabBarItem.title = MyEnums.TabNames.Calendar.rawValue
        
        let addExpenseController = AddExpenseCVC(collectionViewLayout: layout)
        let addExpenseNavController = UINavigationController(rootViewController: addExpenseController)
        addExpenseNavController.tabBarItem.title = MyEnums.TabNames.AddExpense.rawValue
        
        let charts = ChartsCVC(collectionViewLayout: layout)
        let chartsNavcontroller = UINavigationController(rootViewController: charts)
        chartsNavcontroller.tabBarItem.title = MyEnums.TabNames.Charts.rawValue
        
        
        
        
        if #available(iOS 13.0, *) {
            calendarViewController.tabBarItem.image = UIImage(systemName: "calendar")
            addExpenseNavController.tabBarItem.image = UIImage(systemName: "plus")
            chartsNavcontroller.tabBarItem.image = UIImage(systemName: "chart.pie")
        } else {
            // Fallback on earlier versions
        }
        
        
        viewControllers = [calendarViewController, addExpenseNavController, chartsNavcontroller]
        self.tabBar.tintColor = UIColor(rgb: MyEnums.Colours.ORANGE_PUMPKIN.rawValue)
    }
}
