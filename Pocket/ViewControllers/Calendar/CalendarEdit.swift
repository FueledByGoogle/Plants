import UIKit



class CalendarEdit: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate  {
    
    
    var calendarTVCell : CalendarTVCell?
    var categoryField : UITextField?
    var categoryPicker: UIPickerView?
    
    var safeHeight = CGFloat(0)
    
    override func viewDidLoad() {
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = UIColor.systemGray6
    }


    override func viewDidLayoutSubviews() {
        setupCategoryPicker()
        setupLabels()
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
    }



    func setupLabels() {
        
        var cumulativeOffset = (categoryField?.frame.height)!
        // Description label
        let descriptionLabel = UILabel(frame: CGRect(x: 10, y: cumulativeOffset, width: self.view.frame.width-20, height: self.view.frame.height*0.05))
        descriptionLabel.setupStyle(text: "Description:", color: UIColor.label, font: UIFont.preferredFont(forTextStyle: .body))
        self.view.addSubview(descriptionLabel)
        cumulativeOffset += descriptionLabel.frame.height
        
        // Description
        let description = UITextView(frame: CGRect(x: 10, y: cumulativeOffset, width: self.view.frame.width-20, height: self.view.frame.height*0.15))
        description.text = calendarTVCell?.expenseDescription
        description.textColor = UIColor.label
        description.font = UIFont.preferredFont(forTextStyle: .body)
        self.view.addSubview(description)
        cumulativeOffset += description.frame.height + 5
        
        
        // Notes label
        let notesLabel = UILabel(frame: CGRect(x: 10, y: cumulativeOffset, width: self.view.frame.width-20, height: self.view.frame.height*0.05))
        notesLabel.setupStyle(text: "Notes:", color: UIColor.label, font: UIFont.preferredFont(forTextStyle: .body))
        self.view.addSubview(notesLabel)
        cumulativeOffset += notesLabel.frame.height
        
        // Notes
        let notes = UITextView(frame: CGRect(x: 10, y: cumulativeOffset, width: self.view.frame.width-20, height: self.view.frame.height*0.30))
        notes.addDoneButton(title: "Done", target: self, selector: #selector(tapDone))
        notes.text = calendarTVCell?.expenseNotes.text
        notes.textColor = UIColor.label
        notes.font = UIFont.preferredFont(forTextStyle: .body)
        self.view.addSubview(notes)
        
        
        
    }
    
    
    @objc func doneCategoryPicker() {
        categoryField?.text = CategoryEnum.Categories.allCases[categoryPicker!.selectedRow(inComponent: 0)].rawValue
        categoryField?.resignFirstResponder()
    }

    @objc func cancelCategoryPicker() {
        categoryField?.resignFirstResponder()
    }
    
    
    // Text view keyboard
    @objc func tapDone() {
       self.view.endEditing(true)
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
