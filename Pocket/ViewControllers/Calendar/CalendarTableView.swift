import UIKit

/*
    Table view is initially refreshed with current day, further refreshes are called from calendar collection view
 */
class CalendarTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    // Data
    var expenseRowId: [Int] = []
    var expenseCategory: [String] = []
    var expenseAmount: [CGFloat] = []
    var expenseName: [String] = []
    var expenseNotes: [String] = []
    
    let cellId = "TableViewcell"
    
    var currentDate = ""
    
    func viewDidLoad() {
        self.dataSource = self
        self.delegate = self
        self.backgroundColor = .orange
        self.register(CalendarTVCell.self, forCellReuseIdentifier: cellId)
    }
    
    /// Updates the view. start and end date should be in UTC
    func reloadData(referenceDate: Date) {
        expenseCategory.removeAll()
        expenseAmount.removeAll()
        
        // Populate variables
        (expenseCategory, expenseAmount, expenseRowId, expenseName, expenseNotes) = (GLOBAL_userDatabase?.loadExpensesOnDay(referenceDate: referenceDate))!
        
//        print(expenseName, expenseNotes)
        
        currentDate = Date.formatDateAndTimezoneString(date: referenceDate, dateFormat: DatabaseEnum.Date.dataFormat.rawValue, timeZone: .UTC)
        self.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseCategory.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CalendarTVCell
        cell.rowId = expenseRowId[indexPath.row]
        cell.name.text = expenseName[indexPath.row]
        cell.category.text = expenseCategory[indexPath.row]
        cell.notes.text = expenseNotes[indexPath.row]
        cell.amount.text = expenseAmount[indexPath.row].description
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if let cell = self.cellForRow(at: indexPath) as? CalendarTVCell {
                if (GLOBAL_userDatabase?.deleteExpenseEntry(rowId: cell.rowId))! {
                    expenseRowId.remove(at: indexPath.row)
                    expenseName.remove(at: indexPath.row)
                    expenseCategory.remove(at: indexPath.row)
                    expenseNotes.remove(at: indexPath.row)
                    expenseAmount.remove(at: indexPath.row)
                    self.deleteRows(at: [indexPath], with: .automatic)
                    
                    // Flag need to refresh
                    GLOBAL_userDatabase?.needToUpdateData[MyEnums.TabNames.Charts.rawValue] = true
                    GLOBAL_userDatabase?.needToUpdateData[MyEnums.TabNames.Calendar.rawValue] = true
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
