import UIKit
import SQLite3

// for testing purposes we move our testdatabase to <Application_Home>/Library/Caches directory

class Database {
    
    var dbUrl: URL?
    var db: OpaquePointer?
    var dbConnection: Int32?
    
    var stmt: OpaquePointer?
    
    var categories: [String] = []
    var categoryTotal: [CGFloat] = []
    
//    let queryDate = "'2019-11-29'"
//    let queryDate2 = "'2019-11-30'"
    
    init() {
        #if targetEnvironment(simulator)
            print ("simulator")
        #else
            print ("real device")
        #endif
        
//        print (NSHomeDirectory().)
        
        // get file url
        self.dbUrl = Bundle.main.url(
            forResource: DatabaseEnum.UserDatabase.fileName.rawValue,
            withExtension: DatabaseEnum.UserDatabase.fileExtension.rawValue)
        
        if self.dbUrl?.absoluteString == nil {
            print ("Could not get file url")
        } else {
            print ("Database URL: ", dbUrl!)
        }
        
        if openDb() != true {
            print ("Failed to open database")
        }
    }
    
    func InsertExpenseToDatabase(category: String, amount: String) -> Bool {
        
        if VerifyDatabaseSetup() != true { return false }
        
        let insertQuery = "INSERT INTO "
            + DatabaseEnum.ExpenseTable.tableName.rawValue
            + " (customerId, amount, category, entry_date) VALUES (0, ?, ?, \""
            + Date.dateToString(date: Date()) + "\")"
        if prepare(query: insertQuery) != true { return false }

        
        //              binding the parameters
        // amount
        if sqlite3_bind_double(stmt, 1, Double(amount)!) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error binding amount: \(errmsg)")
            return false
        }
        // category
        if sqlite3_bind_text(stmt, 2, category, -1, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error binding category: \(errmsg)")
            return false
        }
        // executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error inserting: \(errmsg)")
            return false
        } else {
            print("Inserted: " + category + ", " + amount + ", " + NSDate().description)
        }
        
        
        if reset() != true { return false }
        if finalize() != true { print("Data inserted") }
        
        return true
    }
    
    func loadCategoriesAndTotals() -> Bool {
        
        if VerifyDatabaseSetup() != true { return false }
        
        let userDataQuery = "SELECT " + DatabaseEnum.ExpenseTable.category.rawValue
            + ", SUM(" + DatabaseEnum.ExpenseTable.amount.rawValue + ") FROM "
            + DatabaseEnum.ExpenseTable.tableName.rawValue
            + " Group BY " + DatabaseEnum.ExpenseTable.category.rawValue
        
        if prepare(query: userDataQuery) != true { return false }
        
        // traverse through all records
        var i = 0
        while sqlite3_step(stmt) == SQLITE_ROW
        {
            let categoryDb = String(cString: sqlite3_column_text(stmt, 0))
            let amountDb = String(cString: sqlite3_column_text(stmt, 1))
            
            guard let amount = NumberFormatter().number(from: amountDb) else {
                print ("Error converting entry ", i+1, " in database category \"Amounts\" to NSNumber format.")
                return false
            }
            
            categoryTotal.append(CGFloat(truncating: amount))
            categories.append(categoryDb)
            
            i += 1
        }
        
        if reset() != true { return false }
        if finalize() != true { print ("Data loaded.") }
        
        return true
    }
    
    
    /// Called before each operation to verify database is set up before performing any operations
    func VerifyDatabaseSetup() -> Bool {
        if dbUrl?.absoluteString == nil {
            print ("Database set up incorrectly.")
            return false
        }
        return true
    }
    
    func prepare(query: String) -> Bool {
        if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print ("Error preparing the database: ", errmsg)
            return false
        }
        return true
    }
    
    func reset() -> Bool {
        if sqlite3_reset(stmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error resetting prepared statement: \(errmsg)")
            return false
        }
        return true
    }
    
    /// finalize prepared statement to recover memory associated with that prepared statement
    func finalize() -> Bool {
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Esrror occured finalizing prepared statement: \(errmsg)")
            return false
        }
        return true
    }
    
    func openDb() -> Bool {
        if dbUrl != nil && (sqlite3_open(dbUrl!.absoluteString, &db) != SQLITE_OK) {
            print ("Error opening database")
            return false
        }
        return true
    }
    
    func closeDb() -> Bool {
        if sqlite3_close(db) != SQLITE_OK{
            print("Error closing database")
            return false
        }
        return true
    }
    
}
