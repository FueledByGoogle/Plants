import UIKit


//TODO: Need to implement scrolling view up
class CalendarEditEntryVC: UIViewController, UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate  {
    
    var calendarTVCell : CalendarTVCell?
    
    // Category
    var categoryPicker: UIPickerView?
    
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.keyboardDismissMode = .interactive // allows keyboard to be dismissed when scroll view is dragged down
        v.translatesAutoresizingMaskIntoConstraints = false
//        v.backgroundColor = .red
        return v
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.leading
        stackView.spacing = 16.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let categoryTextField: UITextFieldNoMenu = {
        let textField = UITextFieldNoMenu()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.preferredFont(forTextStyle: .title1)
        textField.adjustsFontSizeToFitWidth = true
        return textField
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.setupStyle(text: "Amount:", color: UIColor.label, font: UIFont.preferredFont(forTextStyle: .headline))
        return label
    }()
    
    let amountTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.adjustsFontSizeToFitWidth = true
        textField.textAlignment = .left
        textField.keyboardType = UIKeyboardType.decimalPad
        return textField
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.setupStyle(text: "Date:", color: UIColor.label, font: UIFont.preferredFont(forTextStyle: .headline))
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
        return datePicker
    }()
    
    let dateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.adjustsFontSizeToFitWidth = true
        textField.textAlignment = .left
        return textField
    }()
    
    let descriptionLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setupStyle(text: "Description:", color: UIColor.label, font: UIFont.preferredFont(forTextStyle: .headline))
        return label
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.font =  UIFont.preferredFont(forTextStyle: .body)
        return textView
    }()
    
    let notesLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setupStyle(text: "Notes:", color: UIColor.label, font: UIFont.preferredFont(forTextStyle: .headline))
        return label
    }()
    
    let notesTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.font =  UIFont.preferredFont(forTextStyle: .body)
        return textView
    }()
    
    
    // For keyboard
    var activeField: UITextField?
    
    override func viewDidLoad() {
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = UIColor.systemGray6
        self.enableDimissKeyboardOnTapOutside()
        
        
        
        // UI
        setupUI()
        
        // Set delegates to capture events
        descriptionTextView.delegate = self
        notesTextView.delegate = self
        
        let save = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(tapSave))
        navigationItem.rightBarButtonItems = [save]
        
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

         // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    //MARK: UI
    func setupUI() {
        
        self.view.addSubview(scrollView) // scrollView needs to be a subview before adding constraints
//        scrollView.contentSize = contentView.frame.size
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5.0),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5.0),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5.0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5.0),
        ])
        
        //Stack View
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        
        // Category Picker
        categoryPicker = UIPickerView()
        categoryPicker!.frame.size.width = self.view.frame.width
        categoryPicker!.delegate = self
        categoryPicker!.dataSource = self
        
        // Category text field
        categoryTextField.text = calendarTVCell!.expenseCategory
        categoryTextField.inputView = categoryPicker
        categoryTextField.addCancelDoneButton(target: self, doneSelector: #selector(doneCategoryPicker), cancelSelector: #selector(cancelCategoryPicker))
        stackView.addArrangedSubview(categoryTextField)
        categoryTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        
        
        
        // Amount stackview
        let amountStackView = UIStackView()
        amountStackView.axis = NSLayoutConstraint.Axis.horizontal
        amountStackView.distribution = UIStackView.Distribution.equalSpacing
        amountStackView.alignment = UIStackView.Alignment.leading
        amountStackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(amountStackView)
        amountStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        amountStackView.heightAnchor.constraint(equalToConstant: amountLabel.font.lineHeight).isActive = true
        // Amount label
        amountStackView.addArrangedSubview(amountLabel)
        amountLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.3).isActive = true
        amountLabel.heightAnchor.constraint(equalToConstant: amountLabel.font.lineHeight).isActive = true
        // Amount text field
        amountTextField.text = (calendarTVCell?.expenseAmount.text)!
        amountStackView.addArrangedSubview(amountTextField)
        amountTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7).isActive = true
        amountTextField.heightAnchor.constraint(equalToConstant: amountLabel.font.lineHeight).isActive = true
        
        
        // Date stackview
        let dateStackView = UIStackView()
        dateStackView.axis = NSLayoutConstraint.Axis.horizontal
        dateStackView.distribution = UIStackView.Distribution.equalSpacing
        dateStackView.alignment = UIStackView.Alignment.leading
        dateStackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(dateStackView)
        dateStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        dateStackView.heightAnchor.constraint(equalToConstant: amountLabel.font.lineHeight).isActive = true
        // Date label
        dateStackView.addArrangedSubview(dateLabel)
        dateLabel.widthAnchor.constraint(equalTo: dateStackView.widthAnchor, multiplier: 0.3).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: dateLabel.font.lineHeight).isActive = true
        // Date text field
        dateTextField.addCancelDoneButton(target: self, doneSelector: #selector(doneDatePicker), cancelSelector: #selector(cancelDatePicker))
        dateTextField.inputView = datePicker
        dateTextField.text = calendarTVCell!.expenseEntryDate
        dateStackView.addArrangedSubview(dateTextField)
        dateTextField.widthAnchor.constraint(equalTo: dateStackView.widthAnchor, multiplier: 0.7).isActive = true
        dateTextField.heightAnchor.constraint(equalToConstant: dateLabel.font.lineHeight).isActive = true
        
        
        
        // Description label
        stackView.addArrangedSubview(descriptionLabel)
        descriptionLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: descriptionLabel.font.lineHeight).isActive = true
        // Description text
        descriptionTextView.text = calendarTVCell?.expenseDescription
        stackView.addArrangedSubview(descriptionTextView)
        descriptionTextView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        
        
        
        // Notes label
        stackView.addArrangedSubview(notesLabel)
        notesLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        notesLabel.heightAnchor.constraint(equalToConstant: descriptionLabel.font.lineHeight).isActive = true
        // Notes text
        notesTextView.text = calendarTVCell?.expenseNotes.text
        stackView.addArrangedSubview(notesTextView)
        notesTextView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        
        
        /* IMPORTANT!! This makes it so we can scroll!
        The last anchor may seem odd because you're anchoring a view that is x points tall to an anchor that you just anchored to the bottom of the view which is definitely less than x points tall. But this is how Apple wants you to do it. This way, you do not need to create a content view, auto layout does it for you.*/
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }

    
    //MARK: button actions
    /// Date picker done button
    @objc func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = DatabaseEnum.Date.dataFormat.rawValue
        dateTextField.text = formatter.string(from: datePicker.date)
        // Dismiss date picker dialog
        self.scrollView.endEditing(true)
    }
    
    /// Date picker cancel button
    @objc func cancelDatePicker() {
        self.scrollView.endEditing(true)
    }
    
    @objc func doneCategoryPicker() {
        categoryTextField.text = CategoryEnum.Categories.allCases[categoryPicker!.selectedRow(inComponent: 0)].rawValue
        self.scrollView.endEditing(true)
    }

    @objc func cancelCategoryPicker() {
        self.scrollView.endEditing(true)
    }
    
    @objc func tapSave() {
        // Entry validation
        if (amountTextField.text!.filter { $0 == "."}.count) > 1 { // Check for correct number of decimals
            print ("Invalid input, try again")
            return
        }
        let decimalRemoved = amountTextField.text!.replacingOccurrences(of: ".", with: "") // Check for invalid characters
        
        
        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: decimalRemoved)) == false {
            print ("Entered text that contains unsupported characters ")
            return
        }
        else {
            guard let num = Double(amountTextField.text!) else {
                print ("Could not convert number to a float")
                return
            }
            let roundedNum = String(round(100*num)/100) // Round to two decimal places, >= 5 are rounded up
            
            
            if GLOBAL_userDatabase?.updateExpenseInDatabase(rowId: calendarTVCell!.databaseID, category: categoryTextField.text!, amount: roundedNum, date: datePicker.date, description: descriptionTextView.text, notes: notesTextView.text) == false {}
        }
        self.scrollView.endEditing(true)
    }

    //MARK: Picker view properties
    
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
    
    
    
    //MARK: Keyboard
    
    var keyboardHeight: CGFloat = 0
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        // don't forget to subtract tab bar height because keyboard's dictation, emoji includes the tab bar height
        keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom

        scrollView.contentInset.bottom = keyboardHeight
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // reset back the content inset to zero after keyboard is gone
        scrollView.contentInset.bottom = .zero
    }
    
    func keyBoardDidShow(_ notification:Notification) {
    }
    
    
    
    //MARK: Text view protocols
    
    // TODO: Implement scrolling depending on where curosr is
    func textViewDidChange(_ textView: UITextView) {
        
        // Because textview frame is not updated correctly on new and deleted lines we re-calculate it manually here.
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize.init(width: fixedWidth, height: CGFloat(MAXFLOAT)))
        var newFrame = textView.frame
        newFrame.size = CGSize.init(width: CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth))), height: newSize.height)
        
        var lineHeight = CGFloat(0)
        if newSize.height > textView.frame.height { // only scroll if textview is obscured by keyboard
            lineHeight = newSize.height - textView.frame.height
        }
        
        // Convert to scrollview coordinate plane
        let tabBarHeight = (self.tabBarController?.tabBar.frame.size.height ?? 0)
        let keyboardMinY = self.view.frame.height-keyboardHeight+tabBarHeight
        let keyboardMinYConverted = self.view.convert(CGPoint(x: 0, y: keyboardMinY), to: scrollView)
        
        print("KBMinY:", keyboardMinYConverted.y, " TVMaxY:", textView.frame.maxY, " content:", scrollView.contentSize, "content offset:", scrollView.contentOffset)
        
        
        // Get cursor location and convert to scrollview coordinate space
        
        // 'caretRect' is in the 'textView' coordinate space.
        let caretRect = textView.caretRect(for: textView.selectedTextRange!.end)

        // Convert 'caretRect' in the main window coordinate space.
        // Passing 'nil' for the view converts to window base coordinates.
        // Passing any 'UIView' object converts to that view coordinate space.
        let windowRect = textView.convert(caretRect, to: scrollView)
        
        // Bottom of textview is blocked by keyboard
//        if textView.frame.maxY+lineHeight > keyboardMinYConverted.y {
        if !windowRect.maxY.isInfinite && windowRect.maxY > keyboardMinYConverted.y {
            print("Keyboard blocking view")
            
            UIView.animate(withDuration: 0.5, animations: {
                let scrollViewVisibleHeight = self.scrollView.frame.height - self.keyboardHeight + tabBarHeight
//                self.scrollView.contentOffset = CGPoint(x: 0, y: textView.frame.maxY-scrollViewVisibleHeight+lineHeight)
                self.scrollView.contentOffset = CGPoint(x: 0, y: windowRect.maxY-scrollViewVisibleHeight+lineHeight)
                })
        }
    }
}
