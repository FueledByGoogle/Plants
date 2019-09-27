import UIKit
import SQLite3









var user: User = User()

class ExpensesCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId: String = "cellId"
    let backgroundColor: UIColor = UIColor(rgb: 0xe8e8e8)
    // single user
    var user1: User = User()
    
    var colourMapping: [String: Int] = [:]
    
    
    // database
    var db: OpaquePointer?
    let databaseFileName = "TestDatabase"
    let databaseFileExtension = "db"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for some reason if you do not set background it lags between transition ¯\_(ツ)_/¯
        self.navigationItem.title = MyEnums.TabNames.Expenses.rawValue
        self.navigationController?.isNavigationBarHidden = true
        self.collectionView.backgroundColor = backgroundColor
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
//        let layout = UICollectionViewFlowLayout()
//        self.collectionView.collectionViewLayout = layout
//        // gets rid of spacing between cells
//        layout.minimumLineSpacing = 0
//        layout.minimumInteritemSpacing = 0
        populateDataArray()
        dummyInfo()
    }


    // dummy info
    func dummyInfo () {
        user1.setUserId(userId: 0)
        user1.addExpenseType(expenseType: "Transportation")
        user1.addExpenseValue(expenseValue: 100)
        
        user1.addExpenseType(expenseType: "Food")
        user1.addExpenseValue(expenseValue: 300)
        
        user1.addExpenseType(expenseType: "Entertainment")
        user1.addExpenseValue(expenseValue: 50)
        
        
//        The pro approach would be to use an extension:
//        extension Dictionary {
//            public init(keys: [Key], values: [Value]) {
//                precondition(keys.count == values.count)
//
//                self.init()
//
//                for (index, key) in keys.enumerate() {
//                    self[key] = values[index]
//                }
//            }
//        }
        
        for (index, element) in user1.expenseType.enumerated() {
            
            if index < MyEnums.Colours.allCases.count {
                colourMapping[element] = MyEnums.Colours.allCases[index].rawValue
            } else {
                print("not enough colours, setting colour to black")
                colourMapping[element] = 0
            }
        }
    }
    
    // number of sections
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // number of cells in section
    override func collectionView(_ collection: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // where 1 is the pie view
        let numOfCells  = 1 + user1.expenseType.count
        return numOfCells
    }
    
    //  what each cell is going to display
    override func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = UIColor.purple
        
        if indexPath.row == 0 { // pie chart
            let pieView = PieChart(
                frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height),
                categories: &user1.expenseType,
                values: &user1.expenseValue,
                mapping: &colourMapping)
            pieView.backgroundColor = UIColor.white
            cell.contentView.addSubview(pieView)
        } else { // legend for chart
            // category color
            let circleRadius =  cell.frame.height*0.1
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: circleRadius*2, y: cell.frame.height/2), radius: circleRadius, startAngle: 0, endAngle: CGFloat(Float.pi*2), clockwise: true)
            
            let circleLabel = CAShapeLayer()
            circleLabel.path = circlePath.cgPath
            
            // colouring in the circles
            // because our dictionary mapping is in order we can simply iterate through the index, hence the reason of needing to offset by subtracting 1
            circleLabel.fillColor = UIColor(rgb: MyEnums.Colours.allCases[indexPath.row-1].rawValue).cgColor
            cell.contentView.layer.addSublayer(circleLabel)
            
            let categoryLabel = UILabel(frame: CGRect(x: circleRadius*4, y: 0, width: cell.frame.width, height: cell.frame.height))
            // for performance, but probably makes no difference since there's so few UILabels
            categoryLabel.isOpaque = true
            categoryLabel.text = user1.expenseType[indexPath.row-1]
            cell.contentView.addSubview(categoryLabel)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: self.view.frame.width, height: 300)
        if (indexPath.row == 0 ) {
            size = CGSize(width: self.view.frame.width, height: self.view.frame.height*0.55)
        } else {
            size = CGSize(width: self.view.frame.width, height: 50)
        }
        return size
    }
    
    func populateDataArray () {
        let dbPath = Bundle.main.url(forResource: databaseFileName, withExtension: databaseFileExtension)
        
        if (sqlite3_open(dbPath!.absoluteString, &db) != SQLITE_OK && dbPath != nil) {
            print("Error opening database")
        } else {
            print("Successfully opened database")
        }
        // query language
        let queryString = "SELECT * FROM Expense WHERE Date between '2019-01-01' AND '2019-01-01'"
        
        // statement pointer
        var stmt:OpaquePointer?
        // preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing the database: ", errmsg)
            return
        }
        // traverse through all records
        var i = 0
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
