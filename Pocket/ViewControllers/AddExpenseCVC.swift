import UIKit
import SQLite3



var GLOBAL_userDatabase: Database?

class AddExpenseCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    let cellReuseIdentifier = "CategoryCell"
    
    var expenseEntry: UIView?
    var amountEntry: UITextField?
    var descriptionEntry: UITextField?
    var notesEntry: UITextField?
    
    // Used for the Y position of each view section e.g. expense entry -> expense date -> collection view cell begin
    var cumulativeYOffset = UIApplication.shared.statusBarFrame.height
    
    let datePicker: UIDatePicker = UIDatePicker()
    var dateEntry: UITextField?
    var datePickerButton: UIButton?
    var dateUTC = Date() // UTC date of user's entered date when sent to be inserted to database
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize database
               GLOBAL_userDatabase = Database.init()
        
        
       
        
        self.navigationItem.title = MyEnums.TabNames.AddExpense.rawValue
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.collectionView.register(AddExpenseCVCCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        // Dismiss keyboard upon touching outside the keyboard
        self.setupToHideKeyboardOnTapOnView()
        // View setup
        cumulativeYOffset += self.navigationController!.navigationBar.frame.height
        setupExpenseDataEntry()
        
        // Layout
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: (dateEntry?.frame.maxY)!, left: 0, bottom: 0, right: 0)
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        
        // Colors
        if #available(iOS 13.0, *) {
            self.navigationController?.navigationBar.barTintColor = UIColor.systemGray6
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.label]
            self.collectionView.backgroundColor =  UIColor.systemGray6
        } else {
           // Fallback on earlier versions
        }
    }
    
    
    
    /// Sets up expense amount views
    func setupExpenseDataEntry() {
        expenseEntry =  UIView(frame: CGRect(x: 0, y: cumulativeYOffset, width: self.view.frame.width, height: self.view.frame.height * 0.30))
        cumulativeYOffset += (expenseEntry?.frame.height)!
        self.view.addSubview(expenseEntry!)
        
        
        // Expense amount input field
        amountEntry = UITextField(frame: CGRect(x:0,
                                                y: 0,
                                                width: self.view.frame.width,
                                                height: expenseEntry!.frame.height * 0.55))
        amountEntry!.text = "25.6"
        amountEntry!.font = .systemFont(ofSize: 50)
        amountEntry!.adjustsFontSizeToFitWidth = true
        amountEntry!.textAlignment  = .center
        amountEntry!.keyboardType = UIKeyboardType.decimalPad
        amountEntry!.delegate = self
        expenseEntry!.addSubview(amountEntry!)
        
        
        // Expense name label
        let descriptionLabel = UILabel(frame: CGRect(x: 0,
                                                     y: (amountEntry?.frame.height)!,
                                                     width: self.view.frame.width * 0.30,
                                                     height: expenseEntry!.frame.height * 0.15))
        descriptionLabel.text = "Description: "
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .center
//        descriptionLabel.sizeToFit()
        expenseEntry?.addSubview(descriptionLabel)
        // Expense name input field
        descriptionEntry = UITextField(frame: CGRect(x: descriptionLabel.frame.width,
                                                     y: (amountEntry?.frame.maxY)!,
                                              width: self.view.frame.width - descriptionLabel.frame.width,
                                              height: descriptionLabel.frame.height))
        descriptionEntry?.placeholder = "Movie tickets"
        descriptionEntry!.font = .systemFont(ofSize: 14)
        descriptionEntry!.textAlignment = .center
        expenseEntry!.addSubview(descriptionEntry!)
        
        
        // Expense notes label
        let notesLabel = UILabel(frame: CGRect(x: 0,
                                               y: descriptionLabel.frame.maxY,
                                               width: descriptionLabel.frame.width,
                                               height: descriptionLabel.frame.height))
        notesLabel.text = "Notes: "
        notesLabel.font = .systemFont(ofSize: 16)
        notesLabel.textAlignment = .center
        expenseEntry!.addSubview(notesLabel)
        // Expense notes input field
        notesEntry = UITextField(frame: CGRect(x: descriptionLabel.frame.width,
                                               y: descriptionLabel.frame.maxY,
                                               width: (descriptionEntry?.frame.width)!,
                                               height: descriptionLabel.frame.height))
        notesEntry?.placeholder = "Cinema on sunset avenue"
        notesEntry!.font = .systemFont(ofSize: 14)
        notesEntry!.textAlignment  = .center
        expenseEntry!.addSubview(notesEntry!)
    
        
        
        // Date label
        let dateLabel = UILabel(frame: CGRect(x: 0,
                                              y: notesLabel.frame.maxY,
                                              width: descriptionLabel.frame.width,
                                              height: descriptionLabel.frame.height))
        dateLabel.text = "Date: "
        dateLabel.textAlignment = .center
        expenseEntry?.addSubview(dateLabel)
        // Text field
        dateEntry = UITextField(frame: CGRect(x: descriptionLabel.frame.width,
                                                        y:  notesLabel.frame.maxY,
                                                        width: (descriptionEntry?.frame.width)!,
                                                        height: descriptionLabel.frame.height))
        dateEntry!.textAlignment = .center
        dateEntry!.inputView = datePicker
        
        // Format initial display date
        let formatter = DateFormatter()
        formatter.dateFormat = DatabaseEnum.Date.dataFormat.rawValue
        dateEntry!.text = formatter.string(from: Date())
        expenseEntry?.addSubview(dateEntry!)
        
        
        // Toolbar
        let datePickerToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)) // Height has to be 44 or greater?
        datePickerToolBar.barStyle = UIBarStyle.default
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        datePickerToolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        datePickerToolBar.sizeToFit()
        // Add toolbar to datepicker keyboard
        dateEntry!.inputAccessoryView = datePickerToolBar
        
        
        // Colors
        if #available(iOS 13.0, *) {
            descriptionEntry?.textColor = UIColor.systemGray
            notesEntry?.textColor = UIColor.systemGray
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    /// Date picker done button
    @objc func doneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = DatabaseEnum.Date.dataFormat.rawValue
        dateEntry!.text = formatter.string(from: datePicker.date)
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
        cell.backgroundColor = UIColor(rgb: CategoryColourEnum.Colours.allCases[indexPath.row].rawValue)
        cell.label.text = MyEnums.Categories.allCases[indexPath.item].rawValue

        return cell
    }
    
    
    /// What a specific cell's size should be
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    
    /// On user selection of category cell
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Entry validation
        if (amountEntry!.text!.filter { $0 == "."}.count) > 1 { // Check for correct number of decimals
            print ("Invalid input, try again")
            return
        }
        let decimalRemoved = amountEntry!.text!.replacingOccurrences(of: ".", with: "") // Check for invalid characters
        
        
        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: decimalRemoved)) == false {
            print ("Entered text that contains unsupported characters ")
            return
        }
        else {
            guard let num = Double(amountEntry!.text!) else {
                print ("Could not convert number to a float")
                return
            }
            let roundedNum = String(round(100*num)/100) // Round to two decimal places, >= 5 are rounded up
            
            if GLOBAL_userDatabase?.InsertExpenseToDatabase(category: MyEnums.Categories.allCases[indexPath.item].rawValue, amount: roundedNum, date: datePicker.date, description: (descriptionEntry?.text)!, notes: (notesEntry?.text)!) == false {}
        }
    }
}
