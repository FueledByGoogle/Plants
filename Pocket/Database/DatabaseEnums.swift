import Foundation

class DatabaseEnum {
    
    enum UserDatabase: String {
        case fileName = "UserDatabase"
        case fileExtension = "db"
    }
    
    enum ExpenseTable: String {
        case tableName = "ExpenseTable"
        case customerId = "customerId"
        case amount = "amount"
        case category = "category"
        case entryDate = "entry_date"
    }
    
//    enum FilterType {
//        case Day, Month, Year
//    }
}
