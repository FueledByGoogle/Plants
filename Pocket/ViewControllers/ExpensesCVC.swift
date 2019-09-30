import UIKit
import SQLite3


var user: User = User()

class ExpensesCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId: String = "cellId"
    
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
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
//        let layout = UICollectionViewFlowLayout()
//        self.collectionView.collectionViewLayout = layout
//        // gets rid of spacing between cells
//        layout.minimumLineSpacing = 0
//        layout.minimumInteritemSpacing = 0
        populateDataArray()
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
        let numOfCells  = 1 + uniqueCategories.count // + 1 to account for piechart cell
        return numOfCells
    }
    
    /**
        what each cell is going to display
     */
    override func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = UIColor.purple
        
        if indexPath.row == 0 { // pie chart
            let pieView = PieChart(
                frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height),
                categories: &categoryDictionary)
            pieView.backgroundColor = UIColor.white
            cell.contentView.addSubview(pieView)
        } else { // legend for chart
            // draw and position circles
            let circleRadius =  cell.frame.height*0.1
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: circleRadius*2, y: cell.frame.height/2), radius: circleRadius, startAngle: 0, endAngle: CGFloat(Float.pi*2), clockwise: true)
            let circleLabel = CAShapeLayer()
            circleLabel.path = circlePath.cgPath
            
            // fill in circles
            // because our dictionary mapping is in order we can simply iterate through the index, hence the reason of needing to offset by subtracting 1
            if indexPath.row-1 < MyEnums.Colours.allCases.count {
                circleLabel.fillColor = UIColor(rgb: MyEnums.Colours.allCases[indexPath.row-1].rawValue).cgColor
            } else {
                print("not enough colours, grey will be used to reprersent the rest of the colours")
                circleLabel.fillColor = UIColor(rgb: 0x454545).cgColor
            }
            
            
            cell.contentView.layer.addSublayer(circleLabel)
            
            let categoryLabel = UILabel(frame: CGRect(x: circleRadius*4, y: 0, width: cell.frame.width, height: cell.frame.height))
            // for performance, but probably makes no difference since there's so few UILabels
            categoryLabel.isOpaque = true
            categoryLabel.text = Array(categoryDictionary)[indexPath.row-1].key
            cell.contentView.addSubview(categoryLabel)
        }
        
        return cell
    }
    
    /**
        what a specific cell's size should be
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: self.view.frame.width, height: 300)
        if (indexPath.row == 0 ) {
            size = CGSize(width: self.view.frame.width, height: self.view.frame.height * 0.55)
        } else {
            size = CGSize(width: self.view.frame.width, height: 50)
        }
        return size
    }
    
    
    /**
        Read database and map each category to its total value
     */
    func populateDataArray () {
        let dbPath = Bundle.main.url(forResource: databaseFileName, withExtension: databaseFileExtension)
        if (sqlite3_open(dbPath!.absoluteString, &db) != SQLITE_OK && dbPath != nil) {
            print("Error opening database")
        }
        
        // statement pointer
        var stmt:OpaquePointer?
        
        let distinctCategoryQuery = "SELECT DISTINCT Category FROM Expense WHERE Date between " + queryDate + " AND " + queryDate
        
        // preparing distinct category query
        if sqlite3_prepare(db, distinctCategoryQuery, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing the database: ", errmsg)
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

        
        let userDataQuery = "SELECT * FROM Expense WHERE Date between " + queryDate + " AND " + queryDate
        
        // preparing user data query
        if sqlite3_prepare(db, userDataQuery, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing the database: ", errmsg)
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
                print("Error converting entry ", i+1, " in database category \"Amounts\" to NSNumber format.")
                return
            }
            user.addExpenseValue(expenseValue: CGFloat(truncating: amount))
            categoryDictionary[categoryDb]! +=  CGFloat(truncating: amount)
            user.addExpenseType(expenseType: categoryDb)
            
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            guard let date = dateFormatter.date(from: dateDb) else {
//                print("Error converting entry ", i+1, " in database category \"Date\" to Date format.")
//                return
//            }
//            user.addDate(date: date)
            i += 1
        }
    }
}
