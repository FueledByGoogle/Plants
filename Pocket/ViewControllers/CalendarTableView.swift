import UIKit


// not sure if cells are loading properly but for now just testing display
class CalendarTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    
    // Data
    var categories: [String] = []
    var categoryTotal: [CGFloat] = []
    
    
    let cellId = "MyCell"
    
    func viewDidLoad() {
        self.dataSource = self
        self.delegate = self
        self.backgroundColor = .orange
        
        self.register(CalendarTVCell.self, forCellReuseIdentifier: cellId)
        
        print ("Calendar table view loaded")
        
        reloadData(startDate: "2020-01-01 20:00", endDate: "2020-12-30 20:00")
    }
    
    // Updates the view. start and end date should be in UTC
    func reloadData(startDate: String, endDate: String) {
        categories.removeAll()
        categoryTotal.removeAll()
print ("Calendar table refreshed")
        (categories, categoryTotal) = (GLOBAL_userDatabase?.loadCategoriesAndTotals(startingDate: startDate, endingDate: endDate))!
        
        self.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CalendarTVCell
        cell.label.text = categories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
