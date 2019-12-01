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
        
        let AddExpenseController = AddExpenseCVC(collectionViewLayout: layout)
        let AddExpenseNavController = UINavigationController(rootViewController: AddExpenseController)
        AddExpenseNavController.tabBarItem.title = MyEnums.TabNames.Add.rawValue
        
        let expenseController = ExpensesCVC(collectionViewLayout: layout)
        let expenseNavcontroller = UINavigationController(rootViewController: expenseController)
        expenseNavcontroller.tabBarItem.title = MyEnums.TabNames.Expenses.rawValue
        
        viewControllers = [AddExpenseNavController, expenseNavcontroller]
        
    }
}
