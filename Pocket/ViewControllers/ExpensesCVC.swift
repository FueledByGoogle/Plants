import UIKit
import SQLite3
import SwiftKuery
import SwiftKueryORM
import SwiftKuerySQLite

var user: User = User()

class ExpensesCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId: String = "TableViewCellIdentifier"
    
    // database
    var db: OpaquePointer?
    
    
    var uniqueCategories: [String] = []
    var categoryDictionary: [String: CGFloat] = [:]
    
    let queryDate: String = "'2019-01-01'"
    
    var pieView: PieChart?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for some reason if you do not set background it lags between transition ¯\_(ツ)_/¯
        self.navigationItem.title = MyEnums.TabNames.Expenses.rawValue
        self.navigationController?.isNavigationBarHidden = true
        self.collectionView.backgroundColor = UIColor(rgb: 0xe8e8e8)
        self.collectionView?.register(ExpensesCVCCell.self, forCellWithReuseIdentifier: cellId)
        
        populateDataArray()
        
        pieView = PieChart(
            frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.55),
            categories: categoryDictionary)
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
        // where 1 is the pie view
        return uniqueCategories.count
    }
    
    /**
        What each cell is going to display
     */
    override func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ExpensesCVCCell
        cell.backgroundColor = UIColor.purple
        
        if indexPath.row < MyEnums.Colours.allCases.count {
            cell.label.text = Array(categoryDictionary)[indexPath.row].key
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
    func populateDataArray () {
//        For semZero all acquire() calls will block and tryAcquire() calls will return false, until you do a release()
//
//        For semOne the first acquire() calls will succeed and the rest will block until the first one releases
        
        if user_entries_database != nil {
            user_entries_database!.getConnection() { connection, error in
                guard connection != nil else {
                    print ("Unsuccessful connection to database")
                    return
                }
                
                Database.default = Database(user_entries_database!)
                ExpenseCategoryTables.getAllCategories() { result, error in
                    guard let result = result else {
                        print ("ExpenseCVC error", error!)
                        connection?.closeConnection()
                        return
                    }
                    
                    print ("Result: ", result)
                }
                
                connection?.closeConnection()
                print ("ExpenseCVC: Successfully read from database")
            }
            
        } else {
            print ("ExpenseCVC: database is nil")
        }
        
        

//        let distinctCategoryQuery = "SELECT DISTINCT Category FROM expense_tables"
//
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
