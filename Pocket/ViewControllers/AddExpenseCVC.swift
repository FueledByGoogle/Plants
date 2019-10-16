import UIKit
import SQLite3


class AddExpenseCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    let cellReuseIdentifier = "CategoryCell"
    
    var expenseTextField: UITextField = UITextField()
    
    var totalNumCells = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for some reason if you do not set background it lags between transition ¯\_(ツ)_/¯
        self.navigationItem.title = MyEnums.TabNames.Add.rawValue
        self.navigationController?.isNavigationBarHidden = true
        self.collectionView.backgroundColor =  UIColor(rgb: 0xe8e8e8)
        self.collectionView.register(AddExpenseCVCCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        totalNumCells =  1 + MyEnums.Categories.allCases.count + 20
        
        // dismiss keyboard upon touching outside the keyboard
        self.setupToHideKeyboardOnTapOnView()
        
        
        let expenseEntry =  UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.40))
        expenseEntry.backgroundColor = UIColor.red
        
        expenseTextField = UITextField(frame: CGRect(x:0, y: expenseEntry.frame.height/2 - 50, width: expenseEntry.frame.width, height: 100))
        expenseTextField.text = "0"
        expenseTextField.font = .systemFont(ofSize: 50)
        expenseTextField.adjustsFontSizeToFitWidth = true
        expenseTextField.textAlignment  = .center
        expenseTextField.borderStyle = UITextField.BorderStyle.line
        expenseTextField.delegate = self
        expenseTextField.keyboardType = UIKeyboardType.decimalPad
        
        expenseEntry.addSubview(expenseTextField)
        // we don't want the add expense view to scroll with the collection view so we add it to view instead of collection view
        self.view.addSubview(expenseEntry)
        
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: expenseEntry.frame.height + self.view.safeAreaInsets.top, left: 0, bottom: 0, right: 0)

        self.collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    /**
        number of sections
     */
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /**
        number of cells in section
     */
    override func collectionView(_ collection: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalNumCells
    }
    
    /**
        what each cell is going to display
     */
    override func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! AddExpenseCVCCell
        cell.backgroundColor = UIColor.purple
        
        cell.label.text = String(indexPath.row)

        return cell
    }
    
    
    /**
        what a specific cell's size should be
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    /**
         on user selection of cell
     */
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! AddExpenseCVCCell
        print ("category: ", cell.label.text ?? 8888888888888)
        
        // check for correct number of decimals
        if (expenseTextField.text!.filter { $0 == "."}.count) > 1 {
            print("Invalid input, try again")
            return
        }

        // check for invalid characters
        let removedDecimal = expenseTextField.text!.replacingOccurrences(of: ".", with: "")
        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: removedDecimal)) == false {
            print("Entered text that contains unsupported characters ")
        } else {
            print("adding", expenseTextField.text!, "to database")
            let expenseUINavController = self.tabBarController!.viewControllers![1] as! UINavigationController
            let expenseCVC = expenseUINavController.topViewController as! ExpensesCVC
            guard let floatNum = NumberFormatter().number(from: expenseTextField.text!)
                else {
                    print("error")
                return
            }
            expenseCVC.testInt = Double(truncating: floatNum)

            // this reloads that tab each time it is called
//            tabBarController!.selectedIndex = 1 // go to expense tab
        }
    }
    
}
