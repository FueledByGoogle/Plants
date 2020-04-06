import UIKit

/*
 Collection view holds current year and month
 Then using the selected cell the three values, date, month, year is combined
 to create the start and end date to send to query the database
 */
class CalendarCVC: UICollectionView, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UITextFieldDelegate {
    
    var initialLoad = true
    
    var cellWidth = CGFloat(50)
    let cellReuseIdentifier = "cellId"
    
    let currentDay = Date.formatDateAndTimezoneString(date: Date(), dateFormat: "dd", timeZone: .LocalZone)
    var lastSelected: IndexPath?
    
    
    // List Data
    var entryCategory: [String] = []
    var entryAmount: [CGFloat] = []
    
    // Used to update table view
    var calendarTableView: CalendarTableView?
    
    
    var selectedYear = ""
    var selectedMonth = Date.findMonthAsNum(date: Date())
    var setNumOfDays = Date.findNumOfDaysInMonth(date: Date()) // Used to see which cells need to be hidden
    
    func viewDidLoad() {
        self.dataSource = self
        self.delegate = self
        self.backgroundColor =  UIColor.white
        self.register(CalendarCVCCalendarCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        cellWidth = self.frame.width/7
        
        // set selected year
        let (startDate, _) = Date.getStartEndDate(referenceDate: Date(), timeInterval: .Month)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        selectedYear = dateFormatter.string(from: startDate)
    }
    
    
    func viewDidAppear(_ animated: Bool) {
        if initialLoad == true {
            self.collectionView(self, didSelectItemAt: IndexPath(item: Int(currentDay)!-1, section: 0))
            self.selectItem(at: IndexPath(row: Int(currentDay)!-1, section: 0), animated: true, scrollPosition: .top)
            lastSelected = IndexPath(row: Int(currentDay)!-1, section: 0)
            initialLoad = false
        }
        else {
            // Must reselect when coming back from view, otherwise after returning from another clicking another cell will not clear the last selected cell
            self.collectionView(self, didSelectItemAt: lastSelected!)
            self.selectItem(at: lastSelected, animated: true, scrollPosition: .top)
        }
        
        
        print ("current month", selectedMonth)
        print ("number of days in month", setNumOfDays)
    }
    
    
    /// number of cells in section
    func collectionView(_ collection: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return Date.getNumberOfDaysInMonth(date: Date())
        return 31 // we will hide ones we do not need
    }
    
    
    /// what each cell is going to display
    func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! CalendarCVCCalendarCell
//        cell.backgroundColor = UIColor.purple
        
        
        cell.layer.borderWidth = 0.1
        cell.label.text = String(indexPath.row+1)

        cell.date = indexPath.row+1
        // Set cell date (Store as a date string)
//            var dateComponent = DateComponents()
//            dateComponent.day = indexPath.row
        // Set date associated with cell
//            cell.date = Calendar.current.date(byAdding: dateComponent, to: startingDate!)!
        
//        print (cell.date)
        
        // Needed so we when cells are reused we still highlight the correct cell
        if cell.isSelected && cell.backgroundColor != UIColor(rgb: MyEnums.Colours.ORANGE_PUMPKIN.rawValue) {
            cell.backgroundColor = UIColor(rgb: MyEnums.Colours.ORANGE_PUMPKIN.rawValue)
        } else if cell.backgroundColor != UIColor.white{
            cell.backgroundColor = .white
        }
        
        // hide cell if it is not in the current month
        if (indexPath.row+1 > setNumOfDays) {
            cell.isHidden = true
        } else {
            cell.isHidden = false
        }

        return cell
    }
    
    
    /// what a specific cell's size should be
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: self.frame.width/7, height: self.frame.width/7);
        } else {
            return CGSize(width: self.frame.width, height: 30)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCVCCalendarCell {
            cell.backgroundColor = UIColor(rgb: 0xF4AA00)
            lastSelected = indexPath
            
            // Specify date components
            var dateComponents = DateComponents()
            dateComponents.year = Int(selectedYear)
            dateComponents.month = selectedMonth
            dateComponents.day = cell.date
            dateComponents.timeZone = TimeZone(abbreviation: "UTC") // Japan Standard Time
            
            let d1 = Calendar.current.date(from: dateComponents)
            
            
            var dateComponentAdd = DateComponents()
            dateComponentAdd.minute = 1439
            let d2 = Calendar.current.date(byAdding: dateComponentAdd, to: d1!)
            
            // Convert to string
            let s1 = Date.formatDateAndTimezoneString(date: d1!, dateFormat: DatabaseEnum.Date.dataFormat.rawValue, timeZone: .UTC)
            let s2 = Date.formatDateAndTimezoneString(date: d2!, dateFormat: DatabaseEnum.Date.dataFormat.rawValue, timeZone: .UTC)
            
            print (s1, s2)
            
            calendarTableView?.reloadData(startDate: s1 , endDate: s2)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCVCCalendarCell {
            cell.backgroundColor = UIColor.white
        }
    }
}
