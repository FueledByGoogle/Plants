import SwiftKueryORM
import SwiftKuerySQLite
import SwiftKuery
import UIKit


// Table names must end with S
/*
    TODO:
        - query sanitation
        - prepared statements
 */


struct ExpenseTables: Codable {
    
    var customerId: Int
    var amount: Double
    var category: String
    var date: String
    
}

extension ExpenseTables: Model {
    
    /// get sum between specified date
    public static func getSumBetweenDates(categoryName: String) -> [ExpenseTables]? {
        let wait = DispatchSemaphore(value: 0)
            // First get the table
            var table: Table
            do {
                table = try ExpenseTables.getTable()
            } catch {
                print ("UserDatabaseStruct.getSumBetweenDates error: Could not get ExpenseTables. Returning nil.")
                return nil
            }

        // Define result, query and execute
        var entries: [ExpenseTables]? = nil
        
// what I want
// SELECT sum(ExpenseTables.amount) FROM ExpenseTables WHERE ExpenseTables.category='Entertainment'  AND date BETWEEN '2019-01-02' AND '2019-01-02'
        
        let query = Select(from: table).where("ExpenseTables.category="+categoryName+" AND date BETWEEN '2019-01-02' AND '2019-01-02'")
        
        
        // upon completion of executequery, either result, or error will be nil
        ExpenseTables.executeQuery(query: query, parameters: nil) { results, error in
            guard let results = results else {
            print ("UserDatabaseStruct.getSumBetweenDates error", error!)
//            wait.signal()
            return
        }

            entries = results
            print (results)

//            wait.signal()
            return
        }
        
        
        wait.wait()
        return entries
    }
    
    
    
    /// Get expensess between two dates
    public static func getExpensesBetweenDates() -> [ExpenseTables]? {
           
        let wait = DispatchSemaphore(value: 0)
        // First get the table
        var table: Table
        do {
            table = try ExpenseTables.getTable()
        } catch {
            print ("UserDatabaseStruct.getExpensesBetweenDates error: Returning nil.")
            return nil
        }
        
        // Define result, query and execute
        var result: [ExpenseTables]? = nil
        
        
        // use query builder?
        let query = Select(from: table).where("date BETWEEN '2019-01-02' AND '2019-01-02'")
           
        // upon completion of executequery, either result, or error will be nil
        ExpenseTables.executeQuery(query: query, parameters: nil) { results, error in
            guard let results = results else {
                print ("UserDatabaseStruct.getExpensesBetweenDates error", error!)
                wait.signal()
                return
            }
            
            result = results
            wait.signal()
            return
        }
        
        wait.wait()
        return result
    }

}





struct ExpenseCategoryTables: Codable {
    
    var category: String

}


extension ExpenseCategoryTables: Model {
        
    // A synchronous function to get all categories
    public static func getAllCategories() -> [ExpenseCategoryTables]? {
        //        For semZero all acquire() calls will block and tryAcquire() calls will return false, until you do a release()
        //
        //        For semOne the first acquire() calls will succeed and the rest will block until the first one releases
        
        
        let wait = DispatchSemaphore(value: 0)
        // First get the table
        var table: Table
        do {
            table = try ExpenseCategoryTables.getTable()
        } catch {
            print ("UserDatabaseStruct error: Could not get ExpenseCategoryTables. Returning nil.")
            return nil
        }
        
        // Define result, query and execute
        var allCategories: [ExpenseCategoryTables]? = nil
        let query = Select(from: table)

        
        // upon completion of executequery, either result, or error will be nil
        ExpenseCategoryTables.executeQuery(query: query, parameters: nil) { results, error in
            guard let results = results else {
                print ("UserDatabaseStruct getAllCategories", error!)
                wait.signal()
                return
            }
            allCategories = results
            wait.signal()
            return
        }
        wait.wait()
        return allCategories
    }
}
