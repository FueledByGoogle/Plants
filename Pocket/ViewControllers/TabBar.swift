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
        
        
        let addExpenseController = AddExpenseCVC(collectionViewLayout: layout)
        let addExpenseNavController = UINavigationController(rootViewController: addExpenseController)
        addExpenseNavController.tabBarItem.title = MyEnums.TabNames.AddExpense.rawValue
        
        let expenseController = ExpensesCVC(collectionViewLayout: layout)
        let expenseNavcontroller = UINavigationController(rootViewController: expenseController)
        expenseNavcontroller.tabBarItem.title = MyEnums.TabNames.Expenses.rawValue
        
        let calendarView = CalendarView()
        let calendarViewController = UINavigationController(rootViewController: calendarView)
        calendarViewController.tabBarItem.title = MyEnums.TabNames.Calendar.rawValue
        
        viewControllers = [calendarViewController, addExpenseNavController, expenseNavcontroller]
        self.tabBar.tintColor = UIColor(rgb: MyEnums.Colours.ORANGE_PUMPKIN.rawValue)
        
    }
}
