/*
   TODO:
   - Calendar like with list of expenses on that day listed on the bottom
   - Swipe left on calendar day to remove an entry
   - Each calendar box shows total expense on that day
*/
import UIKit


class CalendarView: UIViewController {
    
    var collectionView: CalendarCVC?
    var tableView: CalendarTableView?
    
    
    let datePicker: MonthYearPickerView = MonthYearPickerView()
    var datePickerTextField: UITextField?
    var datePickerButton: UIButton?
    var dateUTC = Date() // UTC date of user's entered date when sent to be inserted to database
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: MyEnums.Colours.ORANGE_Dark.rawValue)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
//        self.navigationItem.title = MyEnums.TabNames.Calendar.rawValue
        self.view.backgroundColor = .black
        
        
        setupDatePicker()
        
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        
        collectionView = CalendarCVC(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width/7*5 + self.navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height), collectionViewLayout: layout)
        collectionView!.viewDidLoad()
        collectionView!.setCollectionViewLayout(layout, animated: false)
        
        
        tableView = CalendarTableView(frame: CGRect(x: 0, y: collectionView!.frame.maxY + 1, width: self.view.frame.width, height: self.view.frame.height - collectionView!.frame.height - self.navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height))
        tableView?.viewDidLoad()
        
        collectionView?.calendarTableView = tableView
        
        self.view.addSubview(collectionView!)
        self.view.addSubview(tableView!)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView?.viewDidAppear(true)
        
        // we want to tell table view to update view
        if GLOBAL_userDatabase?.needToUpdateData[MyEnums.TabNames.Calendar.rawValue] == true {
//                let (d1, d2) = Date.getStartEndDates(timeInterval: lastSelectedButton)
//                reloadData(startDate: d1, endDate: d2)
//                GLOBAL_userDatabase?.needToUpdateData[MyEnums.TabNames.Calendar.rawValue] = false
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
        formatter.dateFormat = "MMM yyyy"
        datePickerTextField!.text = formatter.string(from: Date())
        datePickerTextField?.textColor = .white
        datePickerTextField?.font = .boldSystemFont(ofSize: 18)

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

        datePickerTextField!.text = String(format: "%@ %d", datePicker.months[datePicker.month-1], datePicker.year)
        
        // Dismiss date picker dialog
        self.navigationController?.navigationBar.endEditing(true)
    }
    
    
    /// Date picker cancle button
    @objc func cancelDatePicker(){
        self.navigationController?.navigationBar.endEditing(true)
    }
    
}
