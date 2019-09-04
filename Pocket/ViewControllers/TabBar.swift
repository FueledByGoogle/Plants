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
        let menuController = MenuVc(collectionViewLayout: layout)
        let menuNavController = UINavigationController(rootViewController: menuController)
        menuNavController.tabBarItem.title = MyEnums.TabNames.Menu.rawValue
        
        
        let expensesTab = ExpensesVc()
        let icon2 = UITabBarItem(title: MyEnums.TabNames.Expenses.rawValue, image:  nil, selectedImage: nil)
        expensesTab.tabBarItem = icon2
        
        
        let searchController = SearchVc(collectionViewLayout: layout)
        let searchNavController = UINavigationController(rootViewController: searchController)
        searchNavController.tabBarItem.title = MyEnums.TabNames.Search.rawValue
        
//        viewControllers = [menuNavController, expensesTab, searchNavController]
        viewControllers = [expensesTab, menuNavController, searchNavController]
        
        
        
    }
    
    

}
