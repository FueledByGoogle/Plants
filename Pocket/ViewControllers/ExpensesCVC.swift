import UIKit
import SQLite3



class ExpensesCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId: String = "TableViewCellIdentifier"
    
    // database
    var db: OpaquePointer?
    let databaseFileName = "TestDatabase"
    let databaseFileExtension = "db"
    
    
    var categories: [String] = []
    var categoryTotal: [CGFloat] = []
    
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
            categories: &categories, categoryTotal: &categoryTotal)
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
        return categories.count
    }
    
    /**
        what each cell is going to display
     */
    override func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ExpensesCVCCell
        cell.backgroundColor = UIColor.white
        
        if indexPath.row < MyEnums.Colours.allCases.count {
            cell.label.text = categories[indexPath.row]
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
        guard let dbPath = Bundle.main.url(forResource: DatabaseEnum.UserDatabase.fileName.rawValue, withExtension: DatabaseEnum.UserDatabase.fileExtension.rawValue)
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
        
        
        var i = 0
        
        
        let userDataQuery = "SELECT * FROM "
            + DatabaseEnum.ExpenseTable.tableName.rawValue
            + " WHERE " + DatabaseEnum.ExpenseTable.entryDate.rawValue
            + " BETWEEN " + queryDate + " AND " + queryDate
            + " ORDER BY " + DatabaseEnum.ExpenseTable.category.rawValue
        
        // preparing user data query
        if sqlite3_prepare(db, userDataQuery, -1, &stmt, nil) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print ("Error preparing the database: ", errmsg)
            return
        }
        
        
        
        // traverse through all records
        i = 0
        while sqlite3_step(stmt) == SQLITE_ROW
        {
            let amountDb = String(cString: sqlite3_column_text(stmt, 1))
            let categoryDb = String(cString: sqlite3_column_text(stmt, 2))
            
            guard let amount = NumberFormatter().number(from: amountDb) else {
                print ("Error converting entry ", i+1, " in database category \"Amounts\" to NSNumber format.")
                return
            }
            
            categoryTotal.append(CGFloat(truncating: amount))
            categories.append(categoryDb)
            
            
            i += 1
        }
    }
}
