import UIKit
import SQLite3


var user: User = User()

class ExpensesCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId: String = "TableViewCellIdentifier"
    
    // database
    var db: OpaquePointer?
    let databaseFileName = "TestDatabase"
    let databaseFileExtension = "db"
    
    
    var uniqueCategories: [String] = []
    var categoryDictionary: [String: CGFloat] = [:]
    
    let queryDate = "'2019-01-01'"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for some reason if you do not set background it lags between transition ¯\_(ツ)_/¯
        self.navigationItem.title = MyEnums.TabNames.Expenses.rawValue
        self.navigationController?.isNavigationBarHidden = true
        self.collectionView.backgroundColor = UIColor(rgb: 0xe8e8e8)
        self.collectionView?.register(ExpensesCVCCell.self, forCellWithReuseIdentifier: cellId)
        
        populateDataArray()
        
        let pieView = PieChart(
            frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.55),
            categories: &categoryDictionary)
        pieView.backgroundColor = UIColor.white
        self.view.addSubview(pieView)
        
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: pieView.frame.height + self.view.safeAreaInsets.top, left: 0, bottom: 0, right: 0)

        self.collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    /**
        number of sections
     */
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /**
        number of cells in section
     */
    override func collectionView(_ collection: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // where 1 is the pie view
        return uniqueCategories.count
    }
    
    /**
        what each cell is going to display
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
        what a specific cell's size should be
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 50)
    }
    
    
    /**
        Read database and map each category to its total value
     */
    func populateDataArray () {
        guard let dbPath = Bundle.main.url(forResource: databaseFileName, withExtension: databaseFileExtension)
        else {
            print ("Error opening database file")
            return
        }
        
        
        // opening ocnnection to database
        if (sqlite3_open(dbPath.absoluteString, &db) != SQLITE_OK) {
            print ("Error opening database")
        }
        
        // statement pointer
        var stmt:OpaquePointer?
        
        let distinctCategoryQuery = "SELECT DISTINCT Category FROM expense_table WHERE entry_date between " + queryDate + " AND " + queryDate
        
        // preparing distinct category query
        if sqlite3_prepare(db, distinctCategoryQuery, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print ("Error preparing the database: ", errmsg)
            return
        }
        // traverse through all records
        var i = 0
        while sqlite3_step(stmt) == SQLITE_ROW {
            let categoryDb = String(cString: sqlite3_column_text(stmt, 0))
            uniqueCategories.append(categoryDb)
            i += 1
        }
        // initialize dictionary for storing total value of each category
        for element in uniqueCategories {
            categoryDictionary[element] = 0
        }

        
        let userDataQuery = "SELECT * FROM expense_table WHERE entry_date between " + queryDate + " AND " + queryDate
        
        // preparing user data query
        if sqlite3_prepare(db, userDataQuery, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print ("Error preparing the database: ", errmsg)
            return
        }
        // traverse through all records
        i = 0
        while sqlite3_step(stmt) == SQLITE_ROW {
//            let customerIdDb = String(cString: sqlite3_column_text(stmt, 0))
            let amountDb = String(cString: sqlite3_column_text(stmt, 1))
            let categoryDb = String(cString: sqlite3_column_text(stmt, 2))
//            probably don't need to read the date at all, and just query database with each load
//            let dateDb = String(cString: sqlite3_column_text(stmt, 3))
            
            guard let amount = NumberFormatter().number(from: amountDb) else {
                print ("Error converting entry ", i+1, " in database category \"Amounts\" to NSNumber format.")
                return
            }
            user.addExpenseValue(expenseValue: CGFloat(truncating: amount))
            categoryDictionary[categoryDb]! +=  CGFloat(truncating: amount)
            user.addExpenseType(expenseType: categoryDb)
            
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            guard let date = dateFormatter.date(from: dateDb) else {
//                print ("Error converting entry ", i+1, " in database category \"Date\" to Date format.")
//                return
//            }
//            user.addDate(date: date)
            i += 1
        }
    }
}
