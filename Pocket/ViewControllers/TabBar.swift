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
//        calendarViewController.navigationBar.isHidden = true
        
        let addExpenseController = AddExpenseCVC(collectionViewLayout: layout)
        let addExpenseNavController = UINavigationController(rootViewController: addExpenseController)
        addExpenseNavController.tabBarItem.title = MyEnums.TabNames.AddExpense.rawValue
        
        let charts = ChartsCVC(collectionViewLayout: layout)
        let chartsNavcontroller = UINavigationController(rootViewController: charts)
        chartsNavcontroller.tabBarItem.title = MyEnums.TabNames.Charts.rawValue
        
        // Colors
        calendarViewController.tabBarItem.image = UIImage(systemName: "calendar")
        addExpenseNavController.tabBarItem.image = UIImage(systemName: "plus")
        chartsNavcontroller.tabBarItem.image = UIImage(systemName: "chart.pie")
        
        
        viewControllers = [calendarViewController, addExpenseNavController, chartsNavcontroller]
        self.tabBar.tintColor = UIColor.label
        self.tabBar.barTintColor = UIColor.systemGray6
    }
}
