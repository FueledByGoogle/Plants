import SwiftKueryORM
import SwiftKuery
import UIKit

struct ExpenseTables: Codable {
    
    var customerId: Int
    var amount: Double
    var category: String
    var entry_date: Date
    
}


extension ExpenseTables: Model {
    
    static var dateEncodingFormat: DateEncodingFormat = .timestamp

}


struct ExpenseCategoryTables: Codable {
    
    var category: String

}

extension ExpenseCategoryTables: Model {
    
    
    public static func getAllCategories(oncompletion: @escaping ([ExpenseCategoryTables]?, RequestError?)-> Void) {
        var table: Table
        do {
            table = try ExpenseCategoryTables.getTable()
        } catch {
            print ("UserDatabaseStruct error", error)
            return
        }
        
        let query =  Select(from: table)
        ExpenseCategoryTables.executeQuery(query: query, parameters: nil, oncompletion)
    }
}
