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
    
    // Perhaps have a bool array for each view in tab when for when data for that tab needs to be refreshed
    var needToUpdateData: [String: Bool] = [MyEnums.TabNames.Calendar.rawValue: true,
                                            MyEnums.TabNames.Charts.rawValue: true]
    
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    
    /// Opens up database
    init() {
        #if targetEnvironment(simulator)
            print ("POCKETDEBUG [Database] - Simulator")
            // get file url
            self.dbUrl = Bundle.main.url(
                forResource: DatabaseEnum.UserDatabase.fileName.rawValue,
                withExtension: DatabaseEnum.UserDatabase.fileExtension.rawValue)
//        print (dbUrl?.absoluteURL!) // Where run time files in simulator are located e.g, database files
            if openDb() == true { print ("POCKETDEBUG [Database] - Database successfully opened.") }
        
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
        // We copy over our test database if one does not exist.
        print ("POCKETDEBUG [Database] - For testing purposes we always copy over test database")
        do {
            try FileManager.default.removeItem(atPath: dbUrl!.path)
        } catch {}
        
            do {
                try FileManager.default.copyItem(atPath: Bundle.main.url(forResource: DatabaseEnum.UserDatabase.fileName.rawValue,
                                                                         withExtension: DatabaseEnum.UserDatabase.fileExtension.rawValue)!.path,
                                                 toPath: dbUrl!.path)
                print ("POCKETDEBUG [Database] - File successfully copied to cache.")
                self.dbUrl = cacheUrl.appendingPathComponent("UserDatabase.db").absoluteURL
                if openDb() == true { print ("POCKETDEBUG [Database] - Database successfully opened.") }
            } catch {
                print("POCKETDEBUG [Database] - Failed to copy over file.\n", error)
            }
//        }
        #endif
    }
    
    
    // Sets all values to true so other views know data has changed since their last load
    func updateNeedToUpdateStatus() {
        for (name, _) in needToUpdateData {
            needToUpdateData[name] = true
        }
    }
    
    
    //MARK: Query database
    
    /// update query
    func updateExpenseInDatabase(rowId: Int, category: String, amount: String, date: Date, description: String, notes: String) -> Bool {
        
        // Convert input into string before sending to be inserted
        let dateString = Date.calculateDateIntoString(date: date, dateFormat: DatabaseEnum.Date.dataFormat.rawValue, timeZone: .UTC)
        
        
        if VerifyDatabaseSetup() != true { return false }
        
        
        print (rowId, category, amount, date, description, notes)
        let queryString = "UPDATE ExpenseTable SET amount = ?, category = ?, entry_date = ?, description = ?, notes  = ? WHERE ROWID = ?"

        if prepare(query: queryString) != true {
            print ("Failed to prepare query")
            return false
        }

        
        //              Binding the parameters
        // Note: Column out of index maybe caused by quotes single/doubble outside of question marks
        // Amount
        if sqlite3_bind_double(stmt, 1, Double(amount)!) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error binding amount: \(errmsg)")
            return false
        }
        // Category
        if sqlite3_bind_text(stmt, 2, category, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error binding category: \(errmsg)")
            return false
        }
        // Date
        if sqlite3_bind_text(stmt, 3, dateString, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error binding category: \(errmsg)")
            return false
        }
        // Description
        if sqlite3_bind_text(stmt, 4, description, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error binding category: \(errmsg)")
            return false
        }
        // Notes
        if sqlite3_bind_text(stmt, 5, notes, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error binding category: \(errmsg)")
            return false
        }
        // Row ID
        if sqlite3_bind_text(stmt, 6, String(rowId), -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error binding category: \(errmsg)")
            return false
        }
        // Execute the query to update values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error updating: \(errmsg)")
            return false
        } else {
            print("POCKETDEBUG [Database] - Updated: " + category + ", " + amount + ", " + dateString + ", " + description + ", " + notes)
        }
        
        if reset() != true { return false }
        if finalize() != true { print("Failed to finalize after update") }
        
        updateNeedToUpdateStatus()
        return true
    }
    
    
    /// Inserts expense amount into the database, date is converted to UTC
    func insertExpenseToDatabase(category: String, amount: String, date: Date, description: String, notes: String) -> Bool {
        
        // Convert input into string before sending to be inserted
        let dateString = Date.calculateDateIntoString(date: date, dateFormat: DatabaseEnum.Date.dataFormat.rawValue, timeZone: .UTC)
        
        if VerifyDatabaseSetup() != true { return false }
        
        let queryString = "INSERT INTO "
            + DatabaseEnum.ExpenseTable.tableName.rawValue
            + " (customerId, category, amount, entry_date, description, notes) VALUES (0, ?, ?, ?, ?, ?)"
        if prepare(query: queryString) != true { return false }

        
        //              Binding the parameters
        // Note: Column out of index maybe caused by quotes single/double outside of question marks
        
        if sqlite3_bind_text(stmt, 1, category, -1, SQLITE_TRANSIENT) != SQLITE_OK { // Category
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error binding category: \(errmsg)")
            return false
        }
        // Amount
        if sqlite3_bind_double(stmt, 2, Double(amount)!) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error binding amount: \(errmsg)")
            return false
        }
        // Date
        if sqlite3_bind_text(stmt, 3, dateString, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error binding category: \(errmsg)")
            return false
        }
        // Description
        if sqlite3_bind_text(stmt, 4, description, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error binding category: \(errmsg)")
            return false
        }
        // Notes
        if sqlite3_bind_text(stmt, 5, notes, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error binding category: \(errmsg)")
            return false
        }
        // Execute the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error inserting: \(errmsg)")
            return false
        } else {
            print("POCKETDEBUG [Database] - Inserted: " + category + ", " + amount + ", " + dateString + ", " + description + ", " + notes)
        }
        
        if reset() != true { return false }
        if finalize() != true { print("Failed to finalize after insert") }
        
        updateNeedToUpdateStatus()
        return true
    }
    
    
    /// StartingDate, Ending Date should be according to the format in DatabaseEnum "yyyy-MM-dd HH:mm"
    func loadCategoriesAndTotals(startingDate: String, endingDate: String) -> ([String], [CGFloat]) {
        
        var category: [String] = []
        var categoryAmount: [CGFloat] = []
        
        if VerifyDatabaseSetup() != true { return  (category, categoryAmount) }
        
        
        // Note that we do not need single quote when binding
        let queryString = "SELECT " + DatabaseEnum.ExpenseTable.category.rawValue
            + ", SUM(" + DatabaseEnum.ExpenseTable.amount.rawValue
            + ") FROM " + DatabaseEnum.ExpenseTable.tableName.rawValue
            + " WHERE " + DatabaseEnum.ExpenseTable.entryDate.rawValue
            + " BETWEEN ? AND ?"
            + " GROUP BY " + DatabaseEnum.ExpenseTable.category.rawValue
        if prepare(query: queryString) != true {
            print ("Failed to prepare query")
            return (category, categoryAmount)
        }
        
        
        // Bind variables
        if sqlite3_bind_text(stmt, 1, startingDate, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error binding startingDate: \(errmsg)")
            return (category, categoryAmount)
        }
        if sqlite3_bind_text(stmt, 2, endingDate, -1, SQLITE_TRANSIENT) != SQLITE_OK {
           let errmsg = String(cString: sqlite3_errmsg(db)!)
           print("Error binding endingDate: \(errmsg)")
           return (category, categoryAmount)
        }
        
        // Traverse through all records
        var i = 0
        while sqlite3_step(stmt) == SQLITE_ROW
        {
            let categoryDb = String(cString: sqlite3_column_text(stmt, 0))
            let amountDb = String(cString: sqlite3_column_text(stmt, 1))
            
            guard let amount = NumberFormatter().number(from: amountDb) else {
                print ("Error converting entry ", i+1, " in database category \"Amounts\" to NSNumber format.")
                return (category, categoryAmount)
            }
            categoryAmount.append(CGFloat(truncating: amount))
            category.append(categoryDb)
            i += 1
        }
        if reset() != true { return (category, categoryAmount) }
        if finalize() != true { print ("Failed to finalize after load category totals") }
        
        return (category, categoryAmount)
    }
    
    
    /// Returns all expenses from beginning to the end of a day
    func loadExpensesOnDay(referenceDate: Date) -> ([String], [CGFloat], [String], [Int], [String], [String]) {
        
        let (startingDate, endingDate) = Date.calculateStartEndDatesAsString(referenceDate: referenceDate, timeInterval: .Day)
        
        var rowId: [Int] = []
        var category: [String] = []
        var categoryAmount: [CGFloat] = []
        var entryDate: [String] = []
        var description: [String] = []
        var notes: [String] = []
        
        if VerifyDatabaseSetup() != true { return  (category, categoryAmount, entryDate, rowId, description, notes) }
        
        // Note that we do not need single quote when binding
        let queryString = "SELECT ExpenseTable.rowId, ExpenseTable.category, ExpenseTable.amount, ExpenseTable.entry_date, ExpenseTable.description, ExpenseTable.notes FROM ExpenseTable WHERE ExpenseTable.entry_date BETWEEN ? AND ?"
        
        if prepare(query: queryString) != true { return (category, categoryAmount, entryDate, rowId, description, notes) }
        
        // Bind variables
        if sqlite3_bind_text(stmt, 1, startingDate, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error binding startingDate: \(errmsg)")
            return (category, categoryAmount, entryDate, rowId, description, notes)
        }
        if sqlite3_bind_text(stmt, 2, endingDate, -1, SQLITE_TRANSIENT) != SQLITE_OK {
           let errmsg = String(cString: sqlite3_errmsg(db)!)
           print("Error binding endingDate: \(errmsg)")
           return (category, categoryAmount, entryDate, rowId, description, notes)
        }
        
        // Traverse through all records
        var i = 0
        while sqlite3_step(stmt) == SQLITE_ROW
        {
            let rowIdDb = String(cString: sqlite3_column_text(stmt, 0))
            let categoryDb = String(cString: sqlite3_column_text(stmt, 1))
            let amountDb = String(cString: sqlite3_column_text(stmt, 2))
            let entryDateDb = String(cString: sqlite3_column_text(stmt, 3))
            let descriptionDB = String(cString: sqlite3_column_text(stmt, 4))
            let notesDB = String(cString: sqlite3_column_text(stmt, 5))
            
            // Format to NSNumber
            guard let rowIdNum = NumberFormatter().number(from: rowIdDb) else {
                print ("Error converting entry ", i+1, " in database category \"rowId\" to NSNumber format.")
                return (category, categoryAmount, entryDate, rowId, description, notes)
            }
            guard let amount = NumberFormatter().number(from: amountDb) else {
                print ("Error converting entry ", i+1, " in database category \"Amounts\" to NSNumber format.")
                return (category, categoryAmount, entryDate, rowId, description, notes)
            }
            
            rowId.append(Int(truncating: rowIdNum))
            category.append(categoryDb)
            categoryAmount.append(CGFloat(truncating: amount))
            entryDate.append(entryDateDb)
            description.append(descriptionDB)
            notes.append(notesDB)
            i += 1
        }
        if reset() != true { return (category, categoryAmount, entryDate, rowId, description, notes) }
        if finalize() != true { print ("Failed to finalize after insert load expense on day") }
        
        return (category, categoryAmount, entryDate, rowId, description, notes)
    }
    
    
    /// Delete based on rowId
    func deleteExpenseEntry(rowId: Int) -> Bool {
        
        if VerifyDatabaseSetup() != true { return false }
        
        let queryString = "DELETE FROM ExpenseTable WHERE ROWID = ?"
        if prepare(query: queryString) != true {
            print ("Failed to prepare query")
            return false
        }

        
        //              Binding the parameters
        // Note: Column out of index maybe caused by quotes single/doubble outside of question marks
        
        if sqlite3_bind_text(stmt, 1, String(rowId), -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error binding category: \(errmsg)")
            return false
        }
        
        // Execute the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error deleting row from database: \(errmsg)")
            return false
        } else {
            print("Deleted row with rowId: ", rowId)
        }
        
        if reset() != true { return false }
        if finalize() != true { print("Failed to finalize after deletion") }
        
        updateNeedToUpdateStatus()
        return true
    }
    
    
    
    //MARK: Database base operations
    /// Called before each database operation to verify database is set up before performing any operations
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
