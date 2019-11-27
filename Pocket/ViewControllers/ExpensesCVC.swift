import UIKit
import SQLite3
import SwiftKuery
import SwiftKueryORM
import SwiftKuerySQLite


/*
  TODO:
 
    after having unique categories
    sum each one up between the selected dates
 
 
 
 
 
    - Don't want to reload data if user has not entered any new ones
    - Asynchornously read both unique categories and entires between two dates to speed up process?
 */

class ExpensesCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId: String = "TableViewCellIdentifier"
    
    // database
    var db: OpaquePointer?
    
    
    var categoriesCount = 0
    var categoryTotalDict: [String: CGFloat] = [:]
    
    let queryDate: String = "'2019-01-01'"
    
    var pieView: PieChart?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for some reason if you do not set background it lags between transition ¯\_(ツ)_/¯
        self.navigationItem.title = MyEnums.TabNames.Expenses.rawValue
        self.navigationController?.isNavigationBarHidden = true
        self.collectionView.backgroundColor = UIColor(rgb: 0xe8e8e8)
        self.collectionView?.register(ExpensesCVCCell.self, forCellWithReuseIdentifier: cellId)
        
        getDatabaseValues()
        
        pieView = PieChart(
            frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.55),
            categories: categoryTotalDict)
        pieView!.backgroundColor = UIColor.white
        self.view.addSubview(pieView!)
        
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: pieView!.frame.height + self.view.safeAreaInsets.top, left: 0, bottom: 0, right: 0)

        self.collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {


    }
    
    /**
        Number of sections
     */
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /**
        Number of cells in section
     */
    override func collectionView(_ collection: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesCount
    }
    
    /**
        What each cell is going to display
     */
    override func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ExpensesCVCCell
        cell.backgroundColor = UIColor.purple
        
        if indexPath.row < MyEnums.Colours.allCases.count {
            cell.label.text = Array(categoryTotalDict)[indexPath.row].key
            cell.label.textColor = UIColor(rgb: MyEnums.Colours.allCases[indexPath.row].rawValue)
        }
        
        return cell
    }
    
    /**
        What a specific cell's size should be
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 50)
    }
    
    
    /// Read database and map each category to its total value
    func getDatabaseValues () {

        
        if user_entries_database != nil {
            user_entries_database!.getConnection() { connection, error in
                guard connection != nil else {
                    print ("Unsuccessful connection to database", error!)
                    connection?.closeConnection()
                    return
                }
                
// eventually remove: after implementing on app start initialize orm this can be deleted
                Database.default = Database(user_entries_database!)

// also need to check if return empty list
                
                // Get distinct categories
                let distinctCategories = ExpenseCategoryTables.getAllCategories()
                self.categoriesCount = distinctCategories!.count
                
                
                
// also need to check if return empty list
                print (ExpenseTables.getSumBetweenDates(categoryName: "amount")!)
                
                
                
                
                
                
                connection?.closeConnection()
                print ("ExpenseCVC: Successfully read from database")
            }
            
        } else {
            print ("ExpenseCVC: Database is nil")
        }
        
        /*
            retrieve category, amount, between date/ on a date
            
         */

//        let userDataQuery = "SELECT * FROM expense_tables"
//
//
//            guard let amount = NumberFormatter().number(from: amountDb) else {
//                print ("Error converting entry ", i+1, " in database category \"Amounts\" to NSNumber format.")
//                return
//            }
//            user.addExpenseValue(expenseValue: CGFloat(truncating: amount))
//            categoryDictionary[categoryDb]! +=  CGFloat(truncating: amount)
//            user.addExpenseType(expenseType: categoryDb)
        
        
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            guard let date = dateFormatter.date(from: dateDb) else {
//                print ("Error converting entry ", i+1, " in database category \"Date\" to Date format.")
//                return
//            }
//            user.addDate(date: date)
//            i += 1
//        }
    }
}
