import UIKit
import SQLite3


/*
 may have to reset bindings
 
 sqlite3_reset clears the state that the prepared statement maintained during execution. This sets it back to the initial state, thus "resetting it". Bindings remain intact. The statement can be re-executed. Without resetting it, you will receive an error when you try to execute it.

 sqlite3_clear_bindings will just clear the bindings, but not change the state on the prepared statement. You can't re-execute a prepared statement if you just cleared the bindings.
 */
class Database {
    
    var dbUrl: URL?
    var db: OpaquePointer?
    var dbConnection: Int32?
    
    var stmt: OpaquePointer?
    
    var categories: [String] = []
    var categoryTotal: [CGFloat] = []
    
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    
    /// Opens up database
    init() {
        #if targetEnvironment(simulator)
            print ("Simulator")
            // get file url
            self.dbUrl = Bundle.main.url(
                forResource: DatabaseEnum.UserDatabase.fileName.rawValue,
                withExtension: DatabaseEnum.UserDatabase.fileExtension.rawValue)
        
            if openDb() == true { print ("Database successfully opened.") }
        #else
        let cacheUrl = try! FileManager().url(for: .cachesDirectory,
                                                  in: .userDomainMask,
                                                  appropriateFor: nil,
                                                  create: true)
        self.dbUrl = cacheUrl.appendingPathComponent("UserDatabase.db").absoluteURL
        
//        if FileManager.default.fileExists(atPath: dbUrl!.path) {
//            print ("Database file exists")
//            if openDb() == true { print ("Database successfully opened.") }
//        } else {
//            print ("Database file does not exist!")
        
        print ("For testing purposes always copy over database file")
        do {
            try FileManager.default.removeItem(atPath: dbUrl!.path)
        } catch {}
        
        
        
            do {
                try FileManager.default.copyItem(atPath: Bundle.main.url(forResource: DatabaseEnum.UserDatabase.fileName.rawValue,
                                                                         withExtension: DatabaseEnum.UserDatabase.fileExtension.rawValue)!.path,
                                                 toPath: dbUrl!.path)
                print ("File successfully copied to cache.")
                self.dbUrl = cacheUrl.appendingPathComponent("UserDatabase.db").absoluteURL
                if openDb() == true { print ("Database successfully opened.") }
            } catch {
                print("Failed to copy over file.\n", error)
            }
//        }
        #endif
    }
    
    func InsertExpenseToDatabase(category: String, amount: String) -> Bool {
        
        if VerifyDatabaseSetup() != true { return false }
        
        let queryString = "INSERT INTO "
            + DatabaseEnum.ExpenseTable.tableName.rawValue
            + " (customerId, amount, category, entry_date) VALUES (0, ?, ?, \""
            + Date.dateToString(date: Date(), format: "yyyy-MM-dd HH:mm:ss") + "\")"
        if prepare(query: queryString) != true { return false }

        
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
    
    
    /// Date format without single quotes
    func loadCategoriesAndTotals(startingDate: String, endingDate: String) -> Bool {
        
        if VerifyDatabaseSetup() != true { return false }
        
        categories.removeAll()
        categoryTotal.removeAll()
        
        // Note that we do not need single quote when binding
        let queryString = "SELECT " + DatabaseEnum.ExpenseTable.category.rawValue
            + ", SUM(" + DatabaseEnum.ExpenseTable.amount.rawValue
            + ") FROM " + DatabaseEnum.ExpenseTable.tableName.rawValue
            + " WHERE " + DatabaseEnum.ExpenseTable.entryDate.rawValue
            + " BETWEEN ? AND ?"
            + " GROUP BY " + DatabaseEnum.ExpenseTable.category.rawValue
        if prepare(query: queryString) != true { return false }
        
        
        if sqlite3_bind_text(stmt, 1, startingDate, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error binding startingDate: \(errmsg)")
            return false
        }
        if sqlite3_bind_text(stmt, 2, endingDate, -1, SQLITE_TRANSIENT) != SQLITE_OK {
           let errmsg = String(cString: sqlite3_errmsg(db)!)
           print("Error binding endingDate: \(errmsg)")
           return false
        }
        
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
            print ("Database incorrectly setup. Operation not executed.")
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
    
    /// Finalize prepared statement to recover memory associated with that prepared statement
    func finalize() -> Bool {
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error occured finalizing prepared statement: \(errmsg)")
            return false
        }
        return true
    }
    
    /// Opens a database, if it doesn't exist sqlite3_open creates a blank one
    func openDb() -> Bool {
        if sqlite3_open(dbUrl!.absoluteString, &db) != SQLITE_OK {
            print ("Error opening database.")
            return false
        }
        return true
    }
    
    /// Closes a database
    func closeDb() -> Bool {
        if sqlite3_close(db) != SQLITE_OK{
            print("Error closing database.")
            return false
        }
        return true
    }
    
}
