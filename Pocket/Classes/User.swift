import UIKit

class User {
    
    var userId: Int = 0
    var expenseType: [String] = []
    var expenseValue: [CGFloat] = []
    var date: [Date]  =  []
    
    func User() {
        
    }
    
    //  User  Id
    func setUserId(userId: Int) {
        self.userId = userId
    }
    func getUserId() -> Int {
        return self.userId
    }
    
    // Expense Type
    func addExpenseType(expenseType: String) {
        self.expenseType.append(expenseType)
    }
    func getExpenseTypes() -> Array<String> {
        return self.expenseType
    }
    func getExpenseType(index: Int) -> String {
        return expenseType[index]
    }
    
    // Expense Value
    func addExpenseValue(expenseValue: CGFloat) {
        self.expenseValue.append(expenseValue)
    }
    func getExpenseValue(index: Int) -> CGFloat  {
        return self.expenseValue[index]
    }
    func getexpenseValues() -> Array<CGFloat> {
        return self.expenseValue
    }
    
    //  Date
    func addDate(date: Date) {
        self.date.append(date)
    }
    func getDate(index: Int) -> Date {
        return self.date[index]
    }
    func getDates() -> Array<Date> {
        return self.date
    }
    
}
