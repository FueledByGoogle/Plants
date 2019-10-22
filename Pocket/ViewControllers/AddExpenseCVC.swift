import UIKit
import SQLite3
import SwiftKueryORM
import SwiftKuerySQLite



/*
 TODO:
    - replace total number of cells with unique categories in the future when loading of database data
 */

class AddExpenseCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    let cellReuseIdentifier = "CategoryCell"
    
    var expenseTextField: UITextField = UITextField()
    
    
    // database
    var db: OpaquePointer?
    let databaseFileName = "TestDatabase"
    let databaseFileExtension = "db"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for some reason if you do not set background it lags between transition ¯\_(ツ)_/¯
        self.navigationItem.title = MyEnums.TabNames.Add.rawValue
        self.navigationController?.isNavigationBarHidden = true
        self.collectionView.backgroundColor =  UIColor(rgb: 0xe8e8e8)
        self.collectionView.register(AddExpenseCVCCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        // dismiss keyboard upon touching outside the keyboard
        self.setupToHideKeyboardOnTapOnView()
        
        
        let expenseEntry =  UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.40))
        expenseEntry.backgroundColor = UIColor.red
        
        expenseTextField = UITextField(frame: CGRect(x:0, y: expenseEntry.frame.height/2 - 50, width: expenseEntry.frame.width, height: 100))
        expenseTextField.text = "25.6"
        expenseTextField.font = .systemFont(ofSize: 50)
        expenseTextField.adjustsFontSizeToFitWidth = true
        expenseTextField.textAlignment  = .center
        expenseTextField.borderStyle = UITextField.BorderStyle.line
        expenseTextField.delegate = self
        expenseTextField.keyboardType = UIKeyboardType.decimalPad
        
        expenseEntry.addSubview(expenseTextField)
        // we don't want the add expense view to scroll with the collection view so we add it to view instead of collection view
        self.view.addSubview(expenseEntry)
        
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: expenseEntry.frame.height + self.view.safeAreaInsets.top, left: 0, bottom: 0, right: 0)

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
        return MyEnums.Categories.allCases.count
    }
    
    /**
        what each cell is going to display
     */
    override func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! AddExpenseCVCCell
        cell.backgroundColor = UIColor.purple
        
        cell.label.text = MyEnums.Categories.allCases[indexPath.item].rawValue

        return cell
    }
    
    
    /**
        what a specific cell's size should be
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    /**
         on user selection of cell
     */
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let cell = collectionView.cellForItem(at: indexPath) as! AddExpenseCVCCell
        
        // check for correct number of decimals
        if (expenseTextField.text!.filter { $0 == "."}.count) > 1 {
            print ("Invalid input, try again")
            return
        }

        // check for invalid characters
        let removedDecimal = expenseTextField.text!.replacingOccurrences(of: ".", with: "")
        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: removedDecimal)) == false {
            print ("Entered text that contains unsupported characters ")
        } else {
            let expenseUINavController = self.tabBarController!.viewControllers![1] as! UINavigationController
//            let expenseCVC = expenseUINavController.topViewController as! ExpensesCVC
            guard Double(expenseTextField.text!) != nil
                else {
                    print ("Could not convert number to a float")
                return
            }
            addToDatabase(category: MyEnums.Categories.allCases[indexPath.item].rawValue, amount: expenseTextField.text!)

            // this reloads that tab each time it is called
//            tabBarController!.selectedIndex = 1 // go to expense tab
        }
    }
    
    func addToDatabase(category: String, amount: String) {

        
//        let connection = SQLiteConnection(filename: Bundle.main.url(forResource: databaseFileName, withExtension: databaseFileExtension)!.absoluteString)
//
//        connection.connect() { result in
//            guard result.success else {
//                print ("connection unsuccessful")
//                return
//            }
//            print ("connection successful")
//            // Use connection
//        }
        
        
        
        // open database file
        guard let dbPath = Bundle.main.url(forResource: databaseFileName, withExtension: databaseFileExtension)
        else {
            print ("Error opening database file")
            return
        }

        if (sqlite3_open(dbPath.absoluteString, &db) != SQLITE_OK) {
            print ("Error opening database")
        }

//        let insertQuery = "INSERT INTO expense_table (customerId, amount, category, entry_date) VALUES (0, " + amount + ", \"" + category + "\", \"" + NSDate().description + "\");"
        let insertQuery = "INSERT INTO expense_table (customerId, amount, category, entry_date) VALUES (0, ?, ?, \"2019-10-21 23:29:03\" )"
        
        print (insertQuery)
        // statement pointer
        var stmt:OpaquePointer?

        sqlite3_reset(stmt)

        // preparing query
        if sqlite3_prepare(db, insertQuery, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing the database: ", errmsg)
            return
        }


        //binding the parameters

        // amount
        if sqlite3_bind_double(stmt, 1, Double(amount)!) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failure binding amount: \(errmsg)")
            return
        }

        // category
        if sqlite3_bind_text(stmt, 2, category, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failure binding category: \(errmsg)")
            return
        }






        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        } else {
            print("Inserted: " + category + " " + amount + " " + NSDate().description)
        }

        sqlite3_finalize(stmt)
    }
    
}
