import UIKit

/*
    Class Description:
    Table view is initially refreshed with current day, further refreshes are called from calendar collection view
*/
class CalendarTV: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var navigationController: UINavigationController? // set by Calendar View
    
    // Data
    var expenseID: [Int] = []
    var expenseCategory: [String] = []
    var expenseAmount: [CGFloat] = []
    var expenseEntryDate: [String] = []
    var expenseDescription: [String] = []
    var expenseNotes: [String] = []
    
    var currentDate = ""
    
    private let cellId = "TableViewcell"

    
    func viewDidLoad() {
        self.separatorInset = UIEdgeInsets.zero // So seaprators stretch to the edges of the screen
        self.dataSource = self
        self.delegate = self
        self.register(CalendarTVCell.self, forCellReuseIdentifier: cellId)
        self.backgroundColor = UIColor.systemGray6
    }
    
    
    /// Updates the view. start and end date should be in UTC
    func reloadData(selectedDate: Date) {
        expenseCategory.removeAll()
        expenseAmount.removeAll()
        
        // Populate variables
        (expenseCategory, expenseAmount, expenseEntryDate, expenseID, expenseDescription, expenseNotes) = (GLOBAL_userDatabase?.loadExpensesOnDay(referenceDate: selectedDate))!
        
        currentDate = Date.calculateDateIntoString(date: selectedDate, dateFormat: DatabaseEnum.Date.dataFormat.rawValue, timeZone: .UTC)
        self.reloadData()
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = self.cellForRow(at: indexPath) as? CalendarTVCell {
            
            let editView = CalendarEditEntryVC()
            editView.calendarTVCell = cell
            navigationController?.pushViewController(editView, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CalendarTVCell
        cell.addBottomBorder(cgColor: UIColor.gray.cgColor, height: 1, width: cell.frame.width)
        cell.rowID = indexPath.row
        cell.databaseID = expenseID[indexPath.row]
        cell.expenseCategory = expenseCategory[indexPath.row]
        cell.expenseDescription = expenseDescription[indexPath.row]
        
        // Convert UTC date to local date
        cell.expenseEntryDate = Date.calculateDateTimezoneConversionAsString(date: expenseEntryDate[indexPath.row], format: DatabaseEnum.Date.dataFormat.rawValue, timezoneCurrent: TimeZone.current, timezoneDesired: TimeZone(identifier: "UTC")!)
        
        cell.expenseAmount.text = expenseAmount[indexPath.row].description
        cell.expenseNotes.text = expenseNotes[indexPath.row]
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
                if (GLOBAL_userDatabase?.deleteExpenseEntry(rowId: cell.databaseID))! {
                    expenseID.remove(at: indexPath.row)
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
