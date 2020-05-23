import UIKit

/*
    Table view is initially refreshed with current day, further refreshes are called from calendar collection view
 */
class CalendarTV: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var navigationController: UINavigationController?
    
    // Data
    var expenseRowId: [Int] = []
    var expenseCategory: [String] = []
    var expenseAmount: [CGFloat] = []
    var expenseEntryDate: [String] = []
    var expenseDescription: [String] = []
    var expenseNotes: [String] = []
    
    let cellId = "TableViewcell"
    
    var currentDate = ""
    
    func viewDidLoad() {
        self.separatorInset = UIEdgeInsets.zero // So seaprators stretch to the edges of the screen
        self.dataSource = self
        self.delegate = self
        self.register(CalendarTVCell.self, forCellReuseIdentifier: cellId)
        self.backgroundColor = UIColor.systemGray6
    }
    
    /// Updates the view. start and end date should be in UTC
    func reloadData(referenceDate: Date) {
        expenseCategory.removeAll()
        expenseAmount.removeAll()
        
        // Populate variables
        (expenseCategory, expenseAmount, expenseEntryDate, expenseRowId, expenseDescription, expenseNotes) = (GLOBAL_userDatabase?.loadExpensesOnDay(referenceDate: referenceDate))!
        
        currentDate = Date.formatDateAndTimezoneString(date: referenceDate, dateFormat: DatabaseEnum.Date.dataFormat.rawValue, timeZone: .UTC)
        self.reloadData()
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let editView = CalendarEdit()
        navigationController?.pushViewController(editView, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CalendarTVCell
        cell.addBottomBorder(cgColor: UIColor.gray.cgColor, height: 1, width: cell.frame.width)
        cell.rowId = expenseRowId[indexPath.row]
        cell.categoryAndName.text = expenseCategory[indexPath.row] + ": " + expenseDescription[indexPath.row]
        cell.notes.text = expenseNotes[indexPath.row]
        cell.amount.text = expenseAmount[indexPath.row].description
        cell.backgroundColor = UIColor.systemGray5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseCategory.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if let cell = self.cellForRow(at: indexPath) as? CalendarTVCell {
                if (GLOBAL_userDatabase?.deleteExpenseEntry(rowId: cell.rowId))! {
                    expenseRowId.remove(at: indexPath.row)
                    expenseCategory.remove(at: indexPath.row)
                    expenseAmount.remove(at: indexPath.row)
                    expenseEntryDate.remove(at: indexPath.row)
                    expenseDescription.remove(at: indexPath.row)
                    expenseNotes.remove(at: indexPath.row)
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
