import UIKit



class CalendarEditEntryVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate  {
    
    
    var calendarTVCell : CalendarTVCell?
    
    var categoryField : UITextField?
    var categoryPicker: UIPickerView?
    
    var amountEntry: UITextField?
    
    let datePicker: UIDatePicker = UIDatePicker()
    var dateEntry: UITextField?
    
    var descriptionTextView: UITextView?
    var notesTextView: UITextView?
    
    var cumulativeOffset = CGFloat(0)
    
    override func viewDidLoad() {
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = UIColor.systemGray6
        
        setupCategoryPicker()
        setupAmount()
        setupDatePicker()
        setupLabels()
        
        let save = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(tapSave))
        navigationItem.rightBarButtonItems = [save]
    }
    

    func setupCategoryPicker() {
        // Picker
        categoryPicker = UIPickerView()
        categoryPicker!.frame.size.width = self.view.frame.width
        categoryPicker!.delegate = self
        categoryPicker!.dataSource = self
        
        
        // Category text field
        categoryField = UITextFieldNoMenu(frame: CGRect(x: 10, y: 0, width: self.view.frame.width-20, height: self.view.frame.height*0.15))
        categoryField?.text = calendarTVCell!.expenseCategory
        categoryField?.font = .systemFont(ofSize: 35)
        categoryField?.adjustsFontSizeToFitWidth = true
        categoryField?.inputView = categoryPicker
        categoryField?.addCancelDoneButton(target: self, doneSelector: #selector(doneCategoryPicker), cancelSelector: #selector(cancelCategoryPicker))
        self.view.addSubview(categoryField!)
        
        cumulativeOffset += (categoryField?.frame.height)!
    }
    
    
    func setupAmount() {
        let amountLabel = UILabel(frame: CGRect(x: 10, y: cumulativeOffset,
                                                      width: self.view.frame.width*0.20,
                                                      height: self.view.frame.height * 0.05))
        amountLabel.setupStyle(text: "Amount:", color: UIColor.label, font: UIFont.preferredFont(forTextStyle: .body))
        self.view?.addSubview(amountLabel)
        
        // Expense amount input field
        amountEntry = UITextField(frame: CGRect(x: amountLabel.frame.width+5,  y: cumulativeOffset,
                                                width: self.view.frame.width*0.8-15,
                                                height: amountLabel.frame.height))
        amountEntry!.setupText(text: (calendarTVCell?.expenseAmount.text)!, color: UIColor.label, font: UIFont.preferredFont(forTextStyle: .body))
        
        
        amountEntry!.adjustsFontSizeToFitWidth = true
        amountEntry!.textAlignment  = .center
        amountEntry!.keyboardType = UIKeyboardType.decimalPad
//        amountEntry.delegate = self
        self.view.addSubview(amountEntry!)
        
        cumulativeOffset += amountLabel.frame.height
    }

    
    func setupDatePicker() {
        // Date label
        let dateLabel = UILabel(frame: CGRect(x: 10, y: cumulativeOffset,
                                              width: self.view.frame.width*0.30-10,
                                              height: self.view.frame.height * 0.10))
        dateLabel.setupStyle(text: "Date:", color: UIColor.label, font: UIFont.preferredFont(forTextStyle: .body))
        self.view?.addSubview(dateLabel)
        
        // Date picker
        dateEntry = UITextFieldNoMenu(frame: CGRect(x: dateLabel.frame.width, y: cumulativeOffset,
                                                    width: self.view.frame.width*0.7-10,
                                                    height: dateLabel.frame.height))
        
        dateEntry?.addCancelDoneButton(target: self,  doneSelector: #selector(doneDatePicker), cancelSelector: #selector(cancelDatePicker))
        dateEntry!.textAlignment = .center
        dateEntry!.inputView = datePicker
        
        cumulativeOffset += dateLabel.frame.height
        
        // Format initial display date
//        let intialDate = Date.stringToDate(dateFormat: DatabaseEnum.Date.dataFormat.rawValue, date: calendarTVCell!.expenseEntryDate, timezone: .current)
        dateEntry!.text = calendarTVCell!.expenseEntryDate
        self.view.addSubview(dateEntry!)
    }
    
    
    
    /// Date picker done button
    @objc func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = DatabaseEnum.Date.dataFormat.rawValue
        dateEntry!.text = formatter.string(from: datePicker.date)
        // Dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    
    /// Date picker cancel button
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }


    
    func setupLabels() {
        
        // Description label
        let descriptionLabel = UILabel(frame: CGRect(x: 10, y: cumulativeOffset, width: self.view.frame.width-20, height: self.view.frame.height*0.05))
        descriptionLabel.setupStyle(text: "Description:", color: UIColor.label, font: UIFont.preferredFont(forTextStyle: .body))
        self.view.addSubview(descriptionLabel)
        cumulativeOffset += descriptionLabel.frame.height
        
        // Description text
        descriptionTextView = UITextView(frame: CGRect(x: 10, y: cumulativeOffset, width: self.view.frame.width-20, height: self.view.frame.height*0.15))
        descriptionTextView!.addCancelDoneButton(target: self, doneSelector: #selector(tapDescriptionDone))
        descriptionTextView!.text = calendarTVCell?.expenseDescription
        descriptionTextView!.textColor = UIColor.label
        descriptionTextView!.font = UIFont.preferredFont(forTextStyle: .body)
        self.view.addSubview(descriptionTextView!)
        cumulativeOffset += descriptionTextView!.frame.height + 5
        
        
        // Notes label
        let notesLabel = UILabel(frame: CGRect(x: 10, y: cumulativeOffset, width: self.view.frame.width-20, height: self.view.frame.height*0.05))
        notesLabel.setupStyle(text: "Notes:", color: UIColor.label, font: UIFont.preferredFont(forTextStyle: .body))
        self.view.addSubview(notesLabel)
        cumulativeOffset += notesLabel.frame.height
        
        
        // Notes text
        notesTextView = UITextView(frame: CGRect(x: 10, y: cumulativeOffset, width: self.view.frame.width-20, height: self.view.frame.height*0.30))
        notesTextView!.addCancelDoneButton(target: self, doneSelector: #selector(tapNotesDone))
        notesTextView!.text = calendarTVCell?.expenseNotes.text
        notesTextView!.textColor = UIColor.label
        notesTextView!.font = UIFont.preferredFont(forTextStyle: .body)
        self.view.addSubview(notesTextView!)
        
        cumulativeOffset += notesTextView!.frame.height
    }

    
    
    
    @objc func doneCategoryPicker() {
        categoryField?.text = CategoryEnum.Categories.allCases[categoryPicker!.selectedRow(inComponent: 0)].rawValue
        self.view.endEditing(true)
    }

    @objc func cancelCategoryPicker() {
        self.view.endEditing(true)
    }
    
    @objc func tapDescriptionDone() {
        self.view.endEditing(true)
    }
    
    @objc func tapNotesDone() {
         self.view.endEditing(true)
    }
    
    
    
    @objc func tapSave() {
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
            
            
            if GLOBAL_userDatabase?.updateExpenseInDatabase(rowId: calendarTVCell!.databaseID, category: (categoryField?.text)!, amount: roundedNum, date: datePicker.date, description: (descriptionTextView?.text)!, notes: (notesTextView?.text)!) == false {}
        }
    }

    
    
    // Category Picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CategoryEnum.Categories.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(CategoryEnum.Categories.allCases[row].rawValue)
    }
}
