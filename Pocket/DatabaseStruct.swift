import SwiftKueryORM
import UIKit

struct expense_tables: Codable {
    
    var customerId: Int
    var amount: Double
    var category: String
    var entry_date: Date
    
}


extension expense_tables: Model {
    
    static var dateEncodingFormat: DateEncodingFormat = .timestamp
    
}
