import UIKit


class CalendarView: UIViewController {
    
    var collectionView: CalendarCVC?
    var tableView: CalendarTableView?
    
    
    let datePicker: UIDatePickerMonthYear = UIDatePickerMonthYear()
    var datePickerTextField: UITextField?
    var datePickerButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDatePicker()
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        // Collection view setup
        collectionView = CalendarCVC(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width/7*5 + self.navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height), collectionViewLayout: layout)
        collectionView!.viewDidLoad()
        collectionView!.setCollectionViewLayout(layout, animated: false)
        // Table view setup
        tableView = CalendarTableView(frame: CGRect(x: 0, y: collectionView!.frame.maxY + 1, width: self.view.frame.width, height: self.view.frame.height - collectionView!.frame.height - self.navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height))
        tableView?.viewDidLoad()
        
        collectionView?.calendarTableView = tableView // "pass" table view to collection view
        
        
        
        
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor.systemGray6
            collectionView?.backgroundColor = UIColor.clear
            tableView?.backgroundColor = UIColor.systemGray5
            self.navigationController?.navigationBar.barTintColor = UIColor.systemGray6
        } else {
            // Fallback on earlier versions
        }
        
        self.view.addSubview(collectionView!)
        self.view.addSubview(tableView!)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView?.viewDidAppear(true)
        
        // we want to tell table view to update view
        if GLOBAL_userDatabase?.needToUpdateData[MyEnums.TabNames.Calendar.rawValue] == true {
            tableView?.reloadData(referenceDate: collectionView!.selectedDate)
            GLOBAL_userDatabase?.needToUpdateData[MyEnums.TabNames.Calendar.rawValue] = false
        }
    }
    
    /// Sets up date picker entry views
    func setupDatePicker() {
        // Text field
        datePickerTextField = UITextField(frame: CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.width)!, height: (self.navigationController?.navigationBar.frame.height)!))
        datePickerTextField!.textAlignment = .center
        datePickerTextField!.inputView = datePicker
        // Format initial display date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        datePickerTextField!.text = formatter.string(from: Date())
        datePickerTextField?.font = .boldSystemFont(ofSize: 18)
        if #available(iOS 13.0, *) { // colors
            datePickerTextField?.textColor = UIColor.label
        } else {
            // Fallback on earlier versions
        }
        self.navigationController?.navigationBar.addSubview(datePickerTextField!)


        // Toolbar
        let datePickerToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)) // Height has to be 44 or greater?
        datePickerToolBar.barStyle = UIBarStyle.default
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        datePickerToolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        datePickerToolBar.sizeToFit()
        // Add toolbar to datepicker keyboard
        datePickerTextField!.inputAccessoryView = datePickerToolBar
        
    }
    
    /// Date picker done button
    @objc func doneDatePicker(){

        let newDate = String(format: "%@ %d", datePicker.months[datePicker.month-1], datePicker.year)
        
        if datePickerTextField!.text != newDate {
            datePickerTextField!.text = newDate
            
            // update collection view properties
            collectionView?.selectedMonth = datePicker.month
            collectionView?.setNumOfDays = Date.findNumOfDaysInMonth(year: datePicker.year, month: datePicker.month)
            collectionView?.reloadData() // MUST be before highlighting below, otherwise the highlight will be "cleared"
            // select first item of the month when changing to a new month
            collectionView?.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
            collectionView?.collectionView(collectionView!.self, didSelectItemAt: IndexPath(item: 0, section: 0))
            collectionView?.lastSelected = IndexPath(row: 0, section: 0)
            
            // Specify date components
            var dateComponents = DateComponents()
            dateComponents.year = datePicker.year
            dateComponents.month = datePicker.month
            dateComponents.day = 1
            dateComponents.timeZone = TimeZone.current
            
            tableView?.reloadData(referenceDate: Calendar.current.date(from: dateComponents)!)
        }
        
        // Dismiss date picker dialog
        self.navigationController?.navigationBar.endEditing(true)
    }

    
    /// Date picker cancle button
    @objc func cancelDatePicker(){
        self.navigationController?.navigationBar.endEditing(true)
    }
    
}
