import UIKit
import SQLite3


/*
    TODO:
    - Convert all time format up to seconds
    - Disable pasting
    - Prevent loading if global user databse is not initialize correctly
    - Default set date will not be refreshed when app is left on background and is now on next day
*/

var GLOBAL_userDatabase: Database?

class AddExpenseCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    let cellReuseIdentifier = "CategoryCell"
    
    var expenseTextField: UITextField = UITextField()
    var expenseEntry: UIView?
    
    // Used for the Y position of each view section e.g. expense entry -> expense date -> collection view cell begin
    var cumulativeYOffset = UIApplication.shared.statusBarFrame.height
    
    let datePicker: UIDatePicker = UIDatePicker()
    var datePickerTextField: UITextField?
    var datePickerButton: UIButton?
    var dateUTC = Date() // UTC date of user's entered date when sent to be inserted to database
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: MyEnums.Colours.ORANGE_Dark.rawValue)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationItem.title = MyEnums.TabNames.AddExpense.rawValue
        // If background color is not set application may lag between transitions
        self.collectionView.backgroundColor =  UIColor(rgb: 0xe8e8e8)
        self.collectionView.register(AddExpenseCVCCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        // Dismiss keyboard upon touching outside the keyboard
        self.setupToHideKeyboardOnTapOnView()
        
        // Initialize database
        GLOBAL_userDatabase = Database.init()
        
        cumulativeYOffset += self.navigationController!.navigationBar.frame.height
        
        // View setup
        setupExpenseEntryView()
        setupDatePicker()
        
        // Layout
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: cumulativeYOffset, left: 0, bottom: 0, right: 0)
        self.collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    
    /// Sets up expense amount views
    func setupExpenseEntryView() {
        expenseEntry =  UIView(frame: CGRect(x: 0, y: cumulativeYOffset, width: self.view.frame.width, height: self.view.frame.height * 0.20))
        expenseEntry!.backgroundColor = UIColor.white
        
        // TextField
        expenseTextField = UITextField(frame: CGRect(x:0, y: 0, width: expenseEntry!.frame.width, height: self.view.frame.height * 0.20))
        expenseTextField.text = "25.6"
        expenseTextField.font = .systemFont(ofSize: 50)
//        expenseTextField.textColor = .black
        
        // Text positioning
        expenseTextField.adjustsFontSizeToFitWidth = true
        expenseTextField.textAlignment  = .center
//        expenseTextField.borderStyle = UITextField.BorderStyle.line
        expenseTextField.keyboardType = UIKeyboardType.decimalPad
        expenseTextField.delegate = self
        
        expenseEntry!.addSubview(expenseTextField)
        
        cumulativeYOffset += expenseEntry!.frame.height
        self.view.addSubview(expenseEntry!)
    }
    
    
    /// Sets up date picker entry views
    func setupDatePicker() {
        // View
        let datePickerView = UIView(frame: CGRect(x: 0, y: cumulativeYOffset, width: self.view.frame.width, height: self.view.frame.height * 0.1))
        datePickerView.backgroundColor = UIColor.yellow
        self.view.addSubview(datePickerView)
        
        // Text field
        datePickerTextField = UITextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: datePickerView.frame.height))
        datePickerTextField!.textAlignment = .center
        datePickerTextField!.inputView = datePicker
        
        // Format initial display date
        let formatter = DateFormatter()
        formatter.dateFormat = DatabaseEnum.Date.dataFormat.rawValue
        datePickerTextField!.text = formatter.string(from: Date())
        
        datePickerView.addSubview(datePickerTextField!)
        
        
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
        let formatter = DateFormatter()
        formatter.dateFormat = DatabaseEnum.Date.dataFormat.rawValue
        datePickerTextField!.text = formatter.string(from: datePicker.date)
        dateUTC = datePicker.date
        // Dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    
    /// Date picker cancle button
    @objc func cancelDatePicker(){
        // Dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    
    /// Number of cells in section
    override func collectionView(_ collection: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MyEnums.Categories.allCases.count
    }
    
    
    /// What each cell is going to display
    override func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! AddExpenseCVCCell
        cell.backgroundColor = UIColor.purple
        cell.label.text = MyEnums.Categories.allCases[indexPath.item].rawValue

        return cell
    }
    
    
    /// What a specific cell's size should be
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    
    /// On user selection of cell
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Check for correct number of decimals
        if (expenseTextField.text!.filter { $0 == "."}.count) > 1 {
            print ("Invalid input, try again")
            return
        }
        
        // Check for invalid characters
        let decimalRemoved = expenseTextField.text!.replacingOccurrences(of: ".", with: "")
        
        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: decimalRemoved)) == false {
            print ("Entered text that contains unsupported characters ")
            return
        }
        else {
            guard let numD = Double(expenseTextField.text!) else {
                print ("Could not convert number to a float")
                return
            }
            // Round to two decimal places, >= 5 are rounded up
            let roundedNum = String(round(100*numD)/100)

            
            // Convert input into string before sending to be inserted
            let dateString = Date.formatDateAndTimezoneString(date: datePicker.date, dateFormat: DatabaseEnum.Date.dataFormat.rawValue, timeZone: .UTC)
            
            if GLOBAL_userDatabase?.InsertExpenseToDatabase(
                    category: MyEnums.Categories.allCases[indexPath.item].rawValue,
                    amount: roundedNum, dateUTC: dateString) == false {}
        }
    }
}
