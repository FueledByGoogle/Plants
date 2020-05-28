import UIKit



/*
    Class Description:
 */
class CalendarView: UIViewController {
    
    var collectionView: CalendarCVC?
    var tableView: CalendarTV?
    
    let datePicker: UIDatePickerMonthYear = UIDatePickerMonthYear()
    var datePickerTextField: UITextField?
    var datePickerButton: UIButton?
    
    var cumulativeYOffset = CGFloat(0) // used to place one view after another
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = MyEnums.TabNames.Calendar.rawValue
        self.view.backgroundColor = .black
        
        calculateInitialOffset()
        setupDatePicker()
        setupCollectionView()
        setupTableView()
        
        // Colors
        self.view.backgroundColor = UIColor.systemGray6
        self.navigationController?.navigationBar.barTintColor = UIColor.systemGray6
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView?.viewDidAppear(true)
    }
    
    
    func calculateInitialOffset() {
        // Calculate offset
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        cumulativeYOffset += (window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)
        cumulativeYOffset += (self.navigationController?.navigationBar.frame.height)!
    }
    
    /// Sets up date picker entry views
    func setupDatePicker() {
        // Text field
        let height = self.view.frame.height*0.07
        datePickerTextField = UITextField(frame: CGRect(x: 10, y: cumulativeYOffset, width: self.view.frame.width-20, height: height))
        datePickerTextField!.textAlignment = .left
        datePickerTextField!.inputView = datePicker
        datePickerTextField?.addBottomBorder(cgColor: UIColor.label.cgColor, height: 1, width: (datePickerTextField?.frame.width)!)
        
        cumulativeYOffset += height // we must calculate this way because frame height is incorrect
        
        // Format initial display date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        datePickerTextField!.text = formatter.string(from: Date()) // Returns a string representation of a given date formatted using the receiver’s current settings.
        datePickerTextField?.font = .boldSystemFont(ofSize: 18)
        datePickerTextField?.textColor = UIColor.label
        self.view.addSubview(datePickerTextField!)
        
        
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
    
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        
        let height = self.view.frame.width/7*5
        collectionView = CalendarCVC(frame: CGRect(x: 0, y: cumulativeYOffset+1, width: self.view.frame.width, height: height), collectionViewLayout: layout)
        collectionView!.viewDidLoad()
        collectionView!.setCollectionViewLayout(layout, animated: false)
        self.view.addSubview(collectionView!)
        
        cumulativeYOffset += height
    }
    
    
    func setupTableView() {
        // Used to calculate offset
        let height = self.view.frame.height - cumulativeYOffset - (self.tabBarController?.tabBar.frame.height)!
        
        // Table view setup
        tableView = CalendarTV(frame: CGRect(x: 0, y: cumulativeYOffset, width: self.view.frame.width, height: height))
        tableView?.viewDidLoad()
        tableView?.navigationController = self.navigationController // Used to on cell select the table view can push new view
        collectionView?.calendarTableView = tableView // collection view triggers tableview refreshes
        self.view.addSubview(tableView!)
    }

    
    /// Date picker done button
    @objc func doneDatePicker(){

        let newDate = String(format: "%@ %d", datePicker.months[datePicker.month-1], datePicker.year)
        
        if datePickerTextField!.text != newDate {
            datePickerTextField!.text = newDate
            
            // update collection view properties
            collectionView?.selectedMonth = datePicker.month
            collectionView?.setNumOfDays = Date.calculateNumOfDaysInMonth(year: datePicker.year, month: datePicker.month)
            collectionView?.reloadData() // MUST be before highlighting below, otherwise the highlight will be "cleared"
            
            // select first item of the month when changing to a new month
            collectionView?.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
            collectionView?.collectionView(collectionView!.self, didSelectItemAt: IndexPath(item: 0, section: 0))
            collectionView?.lastSelectedIndexPath = IndexPath(row: 0, section: 0)
            
            // Specify date components
            var dateComponents = DateComponents()
            dateComponents.year = datePicker.year
            dateComponents.month = datePicker.month
            dateComponents.day = 1
            dateComponents.timeZone = TimeZone(identifier: "UTC")
            
            tableView?.reloadData(selectedDate: Calendar.current.date(from: dateComponents)!)
        }
        
        // Dismiss date picker dialog
        self.view.endEditing(true)
    }

    
    /// Date picker cancel button
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
}
