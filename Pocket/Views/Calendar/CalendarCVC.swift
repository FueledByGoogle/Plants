import UIKit

/// Class Description: Collection view holds current year and month.
/// Then using the selected cell the three values date, month,
/// and year is used to create the start and end date to send to query the database.
/// Collection view also triggers further table view reloads
<<<<<<< HEAD:Pocket/Views/Calendar/CalendarCVC.swift
class CalendarCV: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITextFieldDelegate {
=======
class CalendarCVC: UICollectionView, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UITextFieldDelegate {
>>>>>>> a3ea41ac170dbd211e9a1fb2b9503ecacab52623:Pocket/ViewControllers/Calendar/CalendarCVC.swift
    
    private var initialLoad = true
    
    private var cellWidth = CGFloat(50)
    private let cellReuseIdentifier = "cellId"
    
    private let cellDefaultBackgroundColor = UIColor.systemGray6
    
    // List Data
//    var entryCategory: [String] = []
//    var entryAmount: [CGFloat] = []
    
    var calendarTableView: CalendarTV? // Used to update table view
    
    // Selection properties
    var lastSelectedIndexPath: IndexPath = IndexPath(row: 0, section: 0) // Used to highlight last selected cell
    var selectedYear = ""
    var selectedMonth = Date.calculateDateMonthAsInt(date: Date())
    var selectedDate : Date? // Created by using selected Year, Month, Day.
    

    var setNumOfDays = Date.calculateNumOfDaysInMonth(date: Date()) // Used to see which cells need to be hidden
    

    func viewDidLoad() {
        self.dataSource = self
        self.delegate = self
        self.register(CalendarCVCCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.backgroundColor = UIColor.clear
        cellWidth = self.frame.width/7
        
        // set selected year
        let (startDate, _) = Date.calculateStartEndDatesAsDate(referenceDate: Date(), timeInterval: .Month)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        selectedYear = dateFormatter.string(from: startDate)
    }
    
    
    func viewDidAppear(_ animated: Bool) {
        
        // only refresh when it is not the initial load and database has been updated since last load
        if (initialLoad == false && GLOBAL_userDatabase?.needToUpdateData[MyEnums.TabNames.Calendar.rawValue] == true)
        {
            self.collectionView(self, didSelectItemAt: lastSelectedIndexPath)
            self.selectItem(at: lastSelectedIndexPath, animated: true, scrollPosition: .top)
            GLOBAL_userDatabase?.needToUpdateData[MyEnums.TabNames.Calendar.rawValue] = false
        }
        
        if initialLoad == true
        {
            // Use local date to select correct day
            let currentDay = Date.calculateDateIntoString(date: Date(), dateFormat: "dd", timeZone: .current)
            self.collectionView(self, didSelectItemAt: IndexPath(item: Int(currentDay)!-1, section: 0))
            self.selectItem(at: IndexPath(row: Int(currentDay)!-1, section: 0), animated: true, scrollPosition: .top)
            lastSelectedIndexPath = IndexPath(row: Int(currentDay)!-1, section: 0)
            
            GLOBAL_userDatabase?.needToUpdateData[MyEnums.TabNames.Calendar.rawValue] = false
            initialLoad = false
        }
    }
    
    
    //MARK: Collection view
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
    
    /// Did select
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCVCCell {
            cell.backgroundColor = UIColor(rgb: MyEnums.Colours.POCKET_BLUE.rawValue)
            cell.label.textColor = UIColor.white
            lastSelectedIndexPath = indexPath
            
            
            // Specify date components
            var dateComponents = DateComponents()
            dateComponents.year = Int(selectedYear)
            dateComponents.month = selectedMonth
            dateComponents.day = cell.date
            dateComponents.timeZone = TimeZone.current
            selectedDate = Calendar.current.date(from: dateComponents)!
            
            calendarTableView?.reloadData(selectedDate: selectedDate!) // refresh table view
        }
    }

    /// Did deselect
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCVCCell {
            cell.label.textColor = UIColor.label
            cell.backgroundColor = cellDefaultBackgroundColor
        }
    }
}
