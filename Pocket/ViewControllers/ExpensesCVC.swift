import UIKit
import SQLite3


class ExpensesCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId: String = "TableViewCellIdentifier"
    
    // database
    var db: OpaquePointer?
    let databaseFileName = "TestDatabase"
    let databaseFileExtension = "db"
    
    
    var pieView : PieChart?
    var categories: [String] = []
    var categoryTotal: [CGFloat] = []
    
    let queryDate = "'2019-11-29'"
    let queryDate2 = "'2019-11-30'"

    
    var initialLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for some reason if you do not set background it lags between transition ¯\_(ツ)_/¯
        self.navigationItem.title = MyEnums.TabNames.Expenses.rawValue
        self.navigationController?.isNavigationBarHidden = true
        self.collectionView.backgroundColor = UIColor(rgb: 0xe8e8e8)
        self.collectionView?.register(ExpensesCVCCell.self, forCellWithReuseIdentifier: cellId)
        
        if initialLoad == true {initialLoad = false}
        
        populateDataArray()

        pieView = PieChart(
            frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: self.view.frame.width, height: self.view.frame.height * 0.55),
            categories: &categories, categoryTotal: &categoryTotal)
        pieView!.backgroundColor = UIColor.white
        self.view.addSubview(pieView!)
        
        
        let layout = UICollectionViewFlowLayout()
        // Where frame holding cells begin
        layout.sectionInset = UIEdgeInsets(top: pieView!.frame.height, left: 0, bottom: 0, right: 0)
        self.collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if initialLoad == false {
            categories.removeAll()
            categoryTotal.removeAll()
            populateDataArray()
            pieView?.updateData(categories: &categories, categoryTotal: &categoryTotal)
            pieView?.setNeedsDisplay()
            self.collectionView.reloadData() // reloads cells
        }
    }
    
    
    /// number of cells
    override func collectionView(_ collection: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    /// what each cell is going to display
    override func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ExpensesCVCCell
        
        cell.indexPathNum = indexPath.row
        
        cell.label.text = categories[indexPath.row]
        cell.totalLabel.text = categoryTotal[indexPath.row].description
        cell.addViewsWithUpdatedProperties()

        return cell
    }
    
    /// what a specific cell's size should be
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 50)
    }

    
    /// Read database and map each category to its total value
    func populateDataArray () {
        guard let dbPath = Bundle.main.url(forResource: DatabaseEnum.UserDatabase.fileName.rawValue, withExtension: DatabaseEnum.UserDatabase.fileExtension.rawValue)
        else {
            print ("Error opening database file")
            return
        }
        
        
        // opening connection to database
        if (sqlite3_open(dbPath.absoluteString, &db) != SQLITE_OK) {
            print ("Error opening database")
        }
        // statement pointer
        var stmt:OpaquePointer?
        
        
        
        // Calendar.current.date(byAdding: .day, value: 1, to: today) // next day for testing
        let userDataQuery = "SELECT " + DatabaseEnum.ExpenseTable.category.rawValue
            + ", SUM(" + DatabaseEnum.ExpenseTable.amount.rawValue + ") FROM "
            + DatabaseEnum.ExpenseTable.tableName.rawValue
            + " Group BY " + DatabaseEnum.ExpenseTable.category.rawValue
        
        // preparing user data query
        if sqlite3_prepare(db, userDataQuery, -1, &stmt, nil) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print ("Error preparing the database: ", errmsg)
            return
        }
        
        
        
        // traverse through all records
        var i = 0
        while sqlite3_step(stmt) == SQLITE_ROW
        {
            let categoryDb = String(cString: sqlite3_column_text(stmt, 0))
            let amountDb = String(cString: sqlite3_column_text(stmt, 1))
            
            guard let amount = NumberFormatter().number(from: amountDb) else {
                print ("Error converting entry ", i+1, " in database category \"Amounts\" to NSNumber format.")
                return
            }
            
            categoryTotal.append(CGFloat(truncating: amount))
            categories.append(categoryDb)
            
            i += 1
        }
        
        
        sqlite3_close(db)
    }
    
}
