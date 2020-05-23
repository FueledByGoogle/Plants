import UIKit

/*
    Collection view holds current year and month.
    Then using the selected cell the three values date, month, and year is used to create the start and end date to send to query the database.
 
    Collection view also triggers further table view reloads
 */
class CalendarCVC: UICollectionView, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UITextFieldDelegate {
    
    var initialLoad = true
    
    var cellWidth = CGFloat(50)
    let cellReuseIdentifier = "cellId"
    
    let cellDefaultBackgroundColor = UIColor.systemGray6
    
    // List Data
    var entryCategory: [String] = []
    var entryAmount: [CGFloat] = []
    
    var calendarTableView: CalendarTV? // Used to update table view
    
    // Selection properties
    var lastSelected: IndexPath = IndexPath(row: 0, section: 0) // Used to highlight last selected cell
    var selectedDate = Date.formatDateAndTimezone(date: Date(), dateFormat: DatabaseEnum.Date.dataFormat.rawValue, timeZone: .UTC)
    var selectedYear = ""
    var selectedMonth = Date.findMonthAsNum(date: Date())

    var setNumOfDays = Date.findNumOfDaysInMonth(date: Date()) // Used to see which cells need to be hidden
    
    func viewDidLoad() {
        self.dataSource = self
        self.delegate = self
        self.register(CalendarCVCCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.backgroundColor = UIColor.clear
        cellWidth = self.frame.width/7
        
        // set selected year
        let (startDate, _) = Date.getStartEndDate(referenceDate: Date(), timeInterval: .Month)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        selectedYear = dateFormatter.string(from: startDate)
        
        
    }
    
    
    func viewDidAppear(_ animated: Bool) {
        
        if (initialLoad == false && GLOBAL_userDatabase?.needToUpdateData[MyEnums.TabNames.Calendar.rawValue] == true) {
                    self.collectionView(self, didSelectItemAt: lastSelected)
                    self.selectItem(at: lastSelected, animated: true, scrollPosition: .top)
            GLOBAL_userDatabase?.needToUpdateData[MyEnums.TabNames.Calendar.rawValue] = false
        }
        
        
        if initialLoad == true {
            let currentDay = Date.formatDateAndTimezoneString(date: Date(), dateFormat: "dd", timeZone: .LocalZone)
            
            self.collectionView(self, didSelectItemAt: IndexPath(item: Int(currentDay)!-1, section: 0))
            self.selectItem(at: IndexPath(row: Int(currentDay)!-1, section: 0), animated: true, scrollPosition: .top)
            lastSelected = IndexPath(row: Int(currentDay)!-1, section: 0)
            initialLoad = false
        }
        else {
            // Must reselect when coming back from view, otherwise after returning from another clicking another cell will not clear the last selected cell
//            self.collectionView(self, didSelectItemAt: lastSelected)
//            self.selectItem(at: lastSelected, animated: true, scrollPosition: .top)
        }
        

    }
    
    
    /// number of cells in section
    func collectionView(_ collection: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 31 // we will hide ones we do not need
    }
    
    
    /// what each cell is going to display
    func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! CalendarCVCCell
        
        cell.label.text = String(indexPath.row+1)
        cell.date = indexPath.row+1
        
        if cell.isSelected && cell.backgroundColor != UIColor(rgb: MyEnums.Colours.POCKET_BLUE.rawValue) {
            cell.backgroundColor = UIColor(rgb: MyEnums.Colours.POCKET_BLUE.rawValue)
        } else if cell.backgroundColor != cellDefaultBackgroundColor {
            cell.backgroundColor = cellDefaultBackgroundColor
        }
        
        // Hide cell if it is not in the current month
        if (indexPath.row+1 > setNumOfDays) {
            cell.isHidden = true
        } else {
            cell.isHidden = false
        }
        
        return cell
    }
    
    
    /// What a specific cell's size should be
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: self.frame.width/7, height: self.frame.width/7);
        } else {
            return CGSize(width: self.frame.width, height: 30)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCVCCell {
            cell.backgroundColor = UIColor(rgb: MyEnums.Colours.POCKET_BLUE.rawValue)
            cell.label.textColor = UIColor.white
            lastSelected = indexPath
            
            // Specify date components
            var dateComponents = DateComponents()
            dateComponents.year = Int(selectedYear)
            dateComponents.month = selectedMonth
            dateComponents.day = cell.date
            dateComponents.timeZone = TimeZone.current
            
            selectedDate = Calendar.current.date(from: dateComponents)!
            
            calendarTableView?.reloadData(referenceDate: selectedDate) // refresh table view
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCVCCell {
            cell.label.textColor = UIColor.label
            cell.backgroundColor = cellDefaultBackgroundColor
        }
    }
}
