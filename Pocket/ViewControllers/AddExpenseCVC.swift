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
    var cumulativeYOffset = CGFloat(0)
    
    let datePicker: UIDatePicker = UIDatePicker()
    var dateEntry: UITextField?
    var datePickerButton: UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GLOBAL_userDatabase = Database.init()
        self.edgesForExtendedLayout = [] // So our content always appears below navigation bar
        self.navigationItem.title = MyEnums.TabNames.AddExpense.rawValue
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.collectionView.register(AddExpenseCVCCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        // Dismiss keyboard upon touching outside the keyboard
        self.setupToHideKeyboardOnTapOnView()
        // View setup
        setupExpenseDataEntry()
        
        // Layout
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: ((dateEntry?.frame.maxY)!+5.0), left: 0, bottom: 0, right: 0)
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        
        // Colors
        self.navigationController?.navigationBar.barTintColor = UIColor.systemGray6
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.label]
        self.collectionView.backgroundColor =  UIColor.systemGray6
    }
    
    
    
    /// Sets up expense amount views
    func setupExpenseDataEntry() {
        expenseEntry =  UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.30))
        cumulativeYOffset += (expenseEntry?.frame.height)!
        self.view.addSubview(expenseEntry!)
        
        
        // Expense amount input field
        amountEntry = UITextField(frame: CGRect(x:0,  y: 0,
                                                width: self.view.frame.width, height: expenseEntry!.frame.height * 0.55))
        amountEntry?.setupText(text: "25.6", color: UIColor.label, font: UIFont.boldSystemFont(ofSize: 50.0))
        amountEntry!.adjustsFontSizeToFitWidth = true
        amountEntry!.textAlignment  = .center
        amountEntry!.keyboardType = UIKeyboardType.decimalPad
        amountEntry!.delegate = self
        expenseEntry!.addSubview(amountEntry!)
        
        
        // Expense name label
        let descriptionLabel = UILabel(frame: CGRect(x: 0, y: (amountEntry?.frame.height)!,
                                                     width: self.view.frame.width * 0.3,
                                                     height: expenseEntry!.frame.height * 0.15))
        descriptionLabel.setupStyle(text: "Description:", color: UIColor.label, font: UIFont.preferredFont(forTextStyle: .body))
        descriptionLabel.textAlignment = .center
        expenseEntry?.addSubview(descriptionLabel)
        
        // Expense name input field
        descriptionEntry = UITextField(frame: CGRect(x: descriptionLabel.frame.width, y: (amountEntry?.frame.maxY)!,
                                              width: self.view.frame.width*0.7,
                                              height: descriptionLabel.frame.height))
        descriptionEntry?.setupText(text: "", color: UIColor.systemGray, font: UIFont.preferredFont(forTextStyle: .body))
        descriptionEntry?.placeholder = "Movie tickets"
        descriptionEntry!.textAlignment = .center
        expenseEntry!.addSubview(descriptionEntry!)
        
        
        // Notes label
        let notesLabel = UILabel(frame: CGRect(x: 0, y: descriptionLabel.frame.maxY,
                                               width: descriptionLabel.frame.width,
                                               height: descriptionLabel.frame.height))
        notesLabel.setupStyle(text: "Notes:", color: UIColor.label, font: UIFont.preferredFont(forTextStyle: .body))
        notesLabel.textAlignment = .center
        expenseEntry!.addSubview(notesLabel)
        
        // Notes input field
        notesEntry = UITextField(frame: CGRect(x: descriptionLabel.frame.width,  y: descriptionLabel.frame.maxY,
                                               width: (descriptionEntry?.frame.width)!,
                                               height: descriptionLabel.frame.height))
        notesEntry?.setupText(text: "", color: UIColor.systemGray, font: UIFont.preferredFont(forTextStyle: .body))
        notesEntry?.placeholder = "Cinema on sunset avenue"
        notesEntry!.textAlignment  = .center
        expenseEntry!.addSubview(notesEntry!)
    
        
        // Date label
        let dateLabel = UILabel(frame: CGRect(x: 0, y: notesLabel.frame.maxY,
                                              width: descriptionLabel.frame.width,
                                              height: descriptionLabel.frame.height))
        dateLabel.setupStyle(text: "Date:", color: UIColor.label, font: UIFont.preferredFont(forTextStyle: .body))
        dateLabel.textAlignment = .center
        expenseEntry?.addSubview(dateLabel)
        
        // Date picker
        dateEntry = UITextFieldNoMenu(frame: CGRect(x: descriptionLabel.frame.width, y:  notesLabel.frame.maxY,
                                                    width: (descriptionEntry?.frame.width)!,
                                                    height: descriptionLabel.frame.height))
        dateEntry!.textAlignment = .center
        dateEntry!.inputView = datePicker
        dateEntry?.addCancelDoneButton(target: self,  doneSelector: #selector(doneDatePicker), cancelSelector: #selector(cancelDatePicker))
        expenseEntry?.addSubview(dateEntry!)
        
        let formatter = DateFormatter() // Format initial display date
        formatter.dateFormat = DatabaseEnum.Date.dataFormat.rawValue
        dateEntry!.text = formatter.string(from: Date()) // Returns a string representation of a given date formatted using the receiver’s current settings.
    }
    
    
    /// Date picker done button
    @objc func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = DatabaseEnum.Date.dataFormat.rawValue
        dateEntry!.text = formatter.string(from: datePicker.date)
        
        print (dateEntry?.text)
        // Dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    
    /// Date picker cancle button
    @objc func cancelDatePicker() {
        // Dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    
    //MARK: Collection View
    /// Number of cells in section
    override func collectionView(_ collection: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryEnum.Categories.allCases.count
    }
    
    
    /// What each cell is going to display
    override func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! AddExpenseCVCCell
        cell.backgroundColor = UIColor(rgb: CategoryEnum.Colours.allCases[indexPath.row].rawValue)
        cell.label.text = CategoryEnum.Categories.allCases[indexPath.item].rawValue

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
            
            if GLOBAL_userDatabase?.insertExpenseToDatabase(category: CategoryEnum.Categories.allCases[indexPath.item].rawValue, amount: roundedNum, date: datePicker.date, description: (descriptionEntry?.text)!, notes: (notesEntry?.text)!) == false {}
        }
    }
}
