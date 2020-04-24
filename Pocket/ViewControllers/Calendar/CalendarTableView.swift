import UIKit


// not sure if cells are loading properly but for now just testing display
class CalendarTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    
    // Data
    var expenseCategory: [String] = []
    var expenseAmount: [CGFloat] = []
    var expenseDate: [String] = []
    
    
    let cellId = "TableViewcell"
    
    var currentDate = ""
    
    func viewDidLoad() {
        self.dataSource = self
        self.delegate = self
        self.backgroundColor = .orange
        self.register(CalendarTVCell.self, forCellReuseIdentifier: cellId)
        
        print ("Calendar table view loaded")
    }
    
    /// Updates the view. start and end date should be in UTC
    func reloadData(referenceDate: Date) {
        expenseCategory.removeAll()
        expenseAmount.removeAll()
        
        (expenseCategory, expenseAmount, expenseDate) = (GLOBAL_userDatabase?.loadExpensesOnDay(referenceDate: referenceDate))!
        
        currentDate = Date.formatDateAndTimezoneString(date: referenceDate, dateFormat: DatabaseEnum.Date.dataFormat.rawValue, timeZone: .UTC)
        self.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseCategory.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CalendarTVCell
        cell.label.text = expenseCategory[indexPath.row]
        cell.totalLabel.text = expenseAmount[indexPath.row].description
        cell.date = expenseDate[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            expenseCategory.remove(at: indexPath.row)
            expenseAmount.remove(at: indexPath.row)
            expenseDate.remove(at: indexPath.row)
            
            print ("Current Date: ", currentDate)
            
            
            if let cell = self.cellForRow(at: indexPath) as? CalendarTVCell {
                print (cell.date)
            }
            
            self.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
