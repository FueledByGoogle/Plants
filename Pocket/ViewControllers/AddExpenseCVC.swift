import UIKit
import SQLite3

/*
 convert to utc if necessary depending on region for both inserting and retrieving
 */


var GLOBAL_userDatabase: Database?

class AddExpenseCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    let cellReuseIdentifier = "CategoryCell"
    var expenseTextField: UITextField = UITextField()
    var expenseEntry: UIView?
    
    var cumulativeYOffset = UIApplication.shared.statusBarFrame.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // If background color is not set application may lag between transitions
        self.navigationItem.title = MyEnums.TabNames.AddExpense.rawValue
//        self.navigationController?.isNavigationBarHidden = true
        self.collectionView.backgroundColor =  UIColor(rgb: 0xe8e8e8)
        self.collectionView.register(AddExpenseCVCCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        // dismiss keyboard upon touching outside the keyboard
        self.setupToHideKeyboardOnTapOnView()
        
        cumulativeYOffset += self.navigationController!.navigationBar.frame.height
        setupEntryView()
        
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: expenseEntry!.frame.height, left: 0, bottom: 0, right: 0)
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        
        GLOBAL_userDatabase = Database.init()
    }
    
    
    /// number of cells in section
    override func collectionView(_ collection: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MyEnums.Categories.allCases.count
    }
    
    
    /// what each cell is going to display
    override func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! AddExpenseCVCCell
        cell.backgroundColor = UIColor.purple
        cell.label.text = MyEnums.Categories.allCases[indexPath.item].rawValue

        return cell
    }
    
    
    /// what a specific cell's size should be
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    
    /// on user selection of cell
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // check for correct number of decimals
        if (expenseTextField.text!.filter { $0 == "."}.count) > 1 {
            print ("Invalid input, try again")
            return
        }
        
        // check for invalid characters
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
            // round to two decimal places, >= 5 are rounded up
            let roundedNum = String(round(100*numD)/100)

            if GLOBAL_userDatabase?.InsertExpenseToDatabase(
                    category: MyEnums.Categories.allCases[indexPath.item].rawValue,
                    amount: roundedNum) == false {}
        }
    }
    
    func setupEntryView() {
        expenseEntry =  UIView(frame: CGRect(x: 0, y: cumulativeYOffset, width: self.view.frame.width, height: self.view.frame.height * 0.40))
        expenseEntry!.backgroundColor = UIColor.white
                   
        expenseTextField = UITextField(frame: CGRect(x:0, y: expenseEntry!.frame.height/2 - 50, width: expenseEntry!.frame.width, height: 100))
        
        expenseTextField.text = "25.6"
        expenseTextField.font = .systemFont(ofSize: 50)
        expenseTextField.textColor = .black
        
        expenseTextField.adjustsFontSizeToFitWidth = true
        expenseTextField.textAlignment  = .center
        expenseTextField.borderStyle = UITextField.BorderStyle.line
        
        expenseTextField.keyboardType = UIKeyboardType.decimalPad
        expenseTextField.delegate = self

        expenseEntry!.addSubview(expenseTextField)
        cumulativeYOffset += expenseEntry!.frame.height
        self.view.addSubview(expenseEntry!)
    }

}
